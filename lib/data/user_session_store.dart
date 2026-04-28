import 'package:flutter/foundation.dart';

enum UserRole { unknown, member, teamManager }

class RegisteredUser {
  const RegisteredUser({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.password,
    required this.acceptedTerms,
    required this.role,
    required this.isMemberAssignedToTeam,
    required this.hasActivePaidPlan,
    required this.createdAt,
    this.profileImageAssetPath,
  });

  final String fullName;
  final String companyName;
  final String email;
  final String phoneCode;
  final String phoneNumber;
  final String password;
  final bool acceptedTerms;
  final UserRole role;
  final bool isMemberAssignedToTeam;
  final bool hasActivePaidPlan;
  final DateTime createdAt;
  final String? profileImageAssetPath;

  RegisteredUser copyWith({
    String? fullName,
    String? companyName,
    String? email,
    String? phoneCode,
    String? phoneNumber,
    String? password,
    bool? acceptedTerms,
    UserRole? role,
    bool? isMemberAssignedToTeam,
    bool? hasActivePaidPlan,
    DateTime? createdAt,
    String? profileImageAssetPath,
    bool clearProfileImageAssetPath = false,
  }) {
    return RegisteredUser(
      fullName: fullName ?? this.fullName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      role: role ?? this.role,
      isMemberAssignedToTeam:
          isMemberAssignedToTeam ?? this.isMemberAssignedToTeam,
      hasActivePaidPlan: hasActivePaidPlan ?? this.hasActivePaidPlan,
      createdAt: createdAt ?? this.createdAt,
      profileImageAssetPath: clearProfileImageAssetPath
          ? null
          : profileImageAssetPath ?? this.profileImageAssetPath,
    );
  }
}

class UserSessionStore extends ChangeNotifier {
  UserSessionStore._();

  static final UserSessionStore instance = UserSessionStore._();

  final List<RegisteredUser> _registeredUsers = [];
  String? _pendingSignupEmail;
  String? _activeUserEmail;

  UserRole _role = UserRole.unknown;
  bool _isMemberAssignedToTeam = false;
  bool _hasActivePaidPlan = false;

  List<RegisteredUser> get registeredUsers =>
      List<RegisteredUser>.unmodifiable(_registeredUsers);

  bool get hasRegisteredUsers => _registeredUsers.isNotEmpty;

  UserRole get role => _role;
  bool get isMemberAssignedToTeam => _isMemberAssignedToTeam;
  bool get hasActivePaidPlan => _hasActivePaidPlan;

  RegisteredUser? get activeUser {
    final targetEmail = _pendingSignupEmail ?? _activeUserEmail;
    if (targetEmail == null) {
      return null;
    }

    final userIndex = _registeredUsers.indexWhere(
      (user) => user.email == targetEmail,
    );

    if (userIndex == -1) {
      return null;
    }

    return _registeredUsers[userIndex];
  }

  bool registerSignupInfo({
    required String fullName,
    required String companyName,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    required String password,
    required bool acceptedTerms,
    required UserRole role,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_registeredUsers.any((user) => user.email == normalizedEmail)) {
      return false;
    }

    _registeredUsers.add(
      RegisteredUser(
        fullName: fullName.trim(),
        companyName: companyName.trim(),
        email: normalizedEmail,
        phoneCode: phoneCode.trim(),
        phoneNumber: phoneNumber.trim(),
        // Demo-only local storage until backend auth is integrated.
        password: password,
        acceptedTerms: acceptedTerms,
        role: role,
        isMemberAssignedToTeam: role == UserRole.member ? false : true,
        hasActivePaidPlan: role == UserRole.teamManager ? false : true,
        createdAt: DateTime.now(),
        profileImageAssetPath: role == UserRole.teamManager
            ? 'assets/icons/team_manager.png'
            : 'assets/icons/member.png',
      ),
    );

    _role = role;
    _isMemberAssignedToTeam = role == UserRole.member ? false : true;
    _hasActivePaidPlan = role == UserRole.teamManager ? false : true;
    _pendingSignupEmail = normalizedEmail;
    _activeUserEmail = normalizedEmail;
    notifyListeners();
    return true;
  }

  bool loginWithStoredCredentials({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final matchedIndex = _registeredUsers.indexWhere(
      (user) => user.email == normalizedEmail && user.password == password,
    );

    if (matchedIndex == -1) {
      return false;
    }

    final matchedUser = _registeredUsers[matchedIndex];
    _activeUserEmail = matchedUser.email;
    _pendingSignupEmail = null;
    _role = matchedUser.role;
    _isMemberAssignedToTeam = matchedUser.isMemberAssignedToTeam;
    _hasActivePaidPlan = matchedUser.hasActivePaidPlan;
    notifyListeners();
    return true;
  }

  bool updateActiveUserProfile({
    required String fullName,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    String? companyName,
  }) {
    final targetEmail = _pendingSignupEmail ?? _activeUserEmail;
    if (targetEmail == null) {
      return false;
    }

    final userIndex = _registeredUsers.indexWhere(
      (user) => user.email == targetEmail,
    );
    if (userIndex == -1) {
      return false;
    }

    final normalizedEmail = email.trim().toLowerCase();
    final duplicateEmailExists = _registeredUsers.any(
      (user) => user.email == normalizedEmail && user.email != targetEmail,
    );
    if (duplicateEmailExists) {
      return false;
    }

    final currentUser = _registeredUsers[userIndex];
    _registeredUsers[userIndex] = currentUser.copyWith(
      fullName: fullName.trim(),
      companyName: companyName != null ? companyName.trim() : null,
      email: normalizedEmail,
      phoneCode: phoneCode.trim(),
      phoneNumber: phoneNumber.trim(),
    );

    _activeUserEmail = normalizedEmail;
    _pendingSignupEmail = null;
    notifyListeners();
    return true;
  }

  bool setProfileImageAssetForActiveUser({required String assetPath}) {
    final targetEmail = _pendingSignupEmail ?? _activeUserEmail;
    if (targetEmail == null) {
      return false;
    }

    final userIndex = _registeredUsers.indexWhere(
      (user) => user.email == targetEmail,
    );
    if (userIndex == -1) {
      return false;
    }

    _registeredUsers[userIndex] = _registeredUsers[userIndex].copyWith(
      profileImageAssetPath: assetPath,
    );
    notifyListeners();
    return true;
  }

  void setMember({required bool isAssignedToTeam}) {
    _role = UserRole.member;
    _isMemberAssignedToTeam = isAssignedToTeam;
    _hasActivePaidPlan = true;
    _syncRoleToStoredUser();
    notifyListeners();
  }

  void setTeamManager({bool hasActivePaidPlan = false}) {
    _role = UserRole.teamManager;
    _isMemberAssignedToTeam = true;
    _hasActivePaidPlan = hasActivePaidPlan;
    _syncRoleToStoredUser();
    notifyListeners();
  }

  // Temporary setter for local testing until backend plan-check is wired.
  void setTeamManagerPlanStatus({required bool isActive}) {
    if (_role == UserRole.teamManager) {
      _hasActivePaidPlan = isActive;
      _syncRoleToStoredUser();
      notifyListeners();
    }
  }

  void _syncRoleToStoredUser() {
    final targetEmail = _pendingSignupEmail ?? _activeUserEmail;
    if (targetEmail == null) {
      return;
    }

    final userIndex = _registeredUsers.indexWhere(
      (user) => user.email == targetEmail,
    );

    if (userIndex == -1) {
      return;
    }

    _registeredUsers[userIndex] = _registeredUsers[userIndex].copyWith(
      role: _role,
      isMemberAssignedToTeam: _isMemberAssignedToTeam,
      hasActivePaidPlan: _hasActivePaidPlan,
    );
    _activeUserEmail = targetEmail;
    _pendingSignupEmail = null;
  }
}
