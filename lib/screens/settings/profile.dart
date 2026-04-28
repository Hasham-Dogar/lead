import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:leads/data/user_session_store.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late final bool _showCompanyField;
  late String _selectedProfileImageAssetPath;

  static const List<String> _availableProfileAssets = [
    'assets/icons/member.png',
    'assets/icons/team_manager.png',
    'assets/logo.png',
    'assets/logo1.jpg',
  ];

  String _countryCode = '+1';
  String _countryFlag = 'US';

  @override
  void initState() {
    super.initState();

    final activeUser = UserSessionStore.instance.activeUser;
    _showCompanyField =
        activeUser?.role == UserRole.teamManager ||
        (activeUser?.companyName.trim().isNotEmpty ?? false);

    _nameController = TextEditingController(
      text: activeUser?.fullName ?? 'John Doe',
    );
    _companyController = TextEditingController(text: activeUser?.companyName);
    _emailController = TextEditingController(
      text: activeUser?.email ?? 'john@gmail.com',
    );
    _phoneController = TextEditingController(
      text: activeUser?.phoneNumber ?? '323456783',
    );

    _countryCode = _normalizedPhoneCode(activeUser?.phoneCode);
    _selectedProfileImageAssetPath =
        activeUser?.profileImageAssetPath ??
        (_showCompanyField
            ? 'assets/icons/team_manager.png'
            : 'assets/icons/member.png');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(_selectedProfileImageAssetPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: _openProfileImagePicker,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _LabeledField(
              label: 'Full Name',
              child: _buildTextField(
                controller: _nameController,
                hint: 'John Doe',
                prefixIcon: Icons.person_outline,
              ),
            ),
            if (_showCompanyField) ...[
              const SizedBox(height: 20),
              _LabeledField(
                label: 'Company Name',
                child: _buildTextField(
                  controller: _companyController,
                  hint: 'Company Name',
                  prefixIcon: Icons.business_outlined,
                ),
              ),
            ],
            const SizedBox(height: 20),
            _LabeledField(
              label: 'Email',
              child: _buildTextField(
                controller: _emailController,
                hint: 'john@gmail.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
              ),
            ),
            const SizedBox(height: 20),
            _LabeledField(label: 'Phone Number', child: _buildPhoneField()),
            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC6060),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: _handleUpdateProfile,
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _normalizedPhoneCode(String? rawCode) {
    final cleaned = (rawCode ?? '').trim().replaceAll('+', '');
    if (cleaned.isEmpty) {
      return '+1';
    }
    return '+$cleaned';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFC6060),
      ),
    );
  }

  void _handleUpdateProfile() {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final companyName = _showCompanyField ? _companyController.text.trim() : '';

    if (fullName.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
      _showMessage('Please fill in all required fields');
      return;
    }

    if (_showCompanyField && companyName.isEmpty) {
      _showMessage('Please enter company name');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Please enter a valid email');
      return;
    }

    final session = UserSessionStore.instance;
    final isUpdated = session.updateActiveUserProfile(
      fullName: fullName,
      email: email,
      phoneCode: _countryCode.replaceAll('+', ''),
      phoneNumber: phoneNumber,
      companyName: _showCompanyField ? companyName : null,
    );

    if (!isUpdated) {
      _showMessage('Unable to update profile for this account');
      return;
    }

    session.setProfileImageAssetForActiveUser(
      assetPath: _selectedProfileImageAssetPath,
    );

    Navigator.of(context).pop();
  }

  Future<void> _openProfileImagePicker() async {
    final selectedAssetPath = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Profile Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ..._availableProfileAssets.map(
                  (assetPath) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(assetPath),
                    ),
                    title: Text(
                      _profileAssetLabel(assetPath),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: _selectedProfileImageAssetPath == assetPath
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFFFC6060),
                          )
                        : null,
                    onTap: () => Navigator.of(sheetContext).pop(assetPath),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selectedAssetPath == null) {
      return;
    }

    setState(() {
      _selectedProfileImageAssetPath = selectedAssetPath;
    });

    UserSessionStore.instance.setProfileImageAssetForActiveUser(
      assetPath: selectedAssetPath,
    );
  }

  String _profileAssetLabel(String assetPath) {
    if (assetPath.endsWith('member.png')) {
      return 'Member Avatar';
    }
    if (assetPath.endsWith('team_manager.png')) {
      return 'Team Manager Avatar';
    }
    if (assetPath.endsWith('logo1.jpg')) {
      return 'Brand Logo 2';
    }
    return 'Brand Logo';
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: Colors.grey)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFC6060), width: 1.2),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '323456783',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _openCountryPicker,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _countryFlag,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _countryCode,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFFC6060),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _countryCode = '+${country.phoneCode}';
          _countryFlag = country.flagEmoji;
        });
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

