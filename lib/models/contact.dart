class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneCode;
  final String email;
  final String note;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneCode,
    required this.email,
    required this.note,
  });

  String get fullName {
    final name = '${firstName.trim()} ${lastName.trim()}'.trim();
    return name.isEmpty ? 'Unnamed Contact' : name;
  }

  String get formattedPhone =>
      phoneNumber.isEmpty ? '' : '+$phoneCode $phoneNumber';

  Contact copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? phoneCode,
    String? email,
    String? note,
  }) {
    return Contact(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneCode: phoneCode ?? this.phoneCode,
      email: email ?? this.email,
      note: note ?? this.note,
    );
  }
}
