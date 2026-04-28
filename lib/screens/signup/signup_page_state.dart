import 'package:flutter/material.dart';
import 'package:leads/data/user_session_store.dart';
import 'package:leads/screens/home/home_page.dart';
import 'package:leads/screens/signup/signup_page.dart';
import 'package:leads/screens/team_manager_home/team_manager_home_page.dart';
import 'package:leads/screens/signup/widgets/signup_header.dart';
import 'package:leads/screens/signup/widgets/company_name_input_field.dart';
import 'package:leads/screens/signup/widgets/fullname_input_field.dart';
import 'package:leads/screens/signup/widgets/signup_email_input_field.dart';
import 'package:leads/screens/signup/widgets/phone_input_field.dart';
import 'package:leads/screens/signup/widgets/signup_password_input_field.dart';
import 'package:leads/screens/signup/widgets/confirm_password_input_field.dart';
import 'package:leads/screens/signup/widgets/terms_checkbox.dart';
import 'package:leads/screens/signup/widgets/create_account_button.dart';
import 'package:leads/screens/signup/widgets/login_link.dart';

class SignupPageState extends State<SignupPage> {
  late TextEditingController _fullNameController;
  late TextEditingController _companyNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _agreedToTerms = false;
  String _selectedPhoneCode = '1';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _companyNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFC6060),
      ),
    );
  }

  void _handleCreateAccount() {
    final isTeamManager = widget.selectedRole == UserRole.teamManager;
    final fullName = _fullNameController.text.trim();
    final companyName = _companyNameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (isTeamManager && companyName.isEmpty) {
      _showMessage('Please enter company name');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    if (!_agreedToTerms) {
      _showMessage('Please agree to terms and conditions');
      return;
    }

    final isSaved = UserSessionStore.instance.registerSignupInfo(
      fullName: fullName,
      companyName: isTeamManager ? companyName : '',
      email: email,
      phoneCode: _selectedPhoneCode,
      phoneNumber: phoneNumber,
      password: password,
      acceptedTerms: _agreedToTerms,
      role: widget.selectedRole,
    );

    if (!isSaved) {
      _showMessage('An account with this email already exists');
      return;
    }

    if (isTeamManager) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TeamManagerHomePage(showPlanActivationDialog: true),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SignupHeader(),
                const SizedBox(height: 32),
                FullnameInputField(controller: _fullNameController),
                const SizedBox(height: 24),
                SignupEmailInputField(controller: _emailController),
                const SizedBox(height: 24),
                PhoneInputField(
                  controller: _phoneController,
                  onCountryChanged: (country) {
                    _selectedPhoneCode = country.phoneCode;
                  },
                ),
                if (widget.selectedRole == UserRole.teamManager) ...[
                  const SizedBox(height: 24),
                  CompanyNameInputField(controller: _companyNameController),
                ],
                const SizedBox(height: 24),
                SignupPasswordInputField(controller: _passwordController),
                const SizedBox(height: 24),
                ConfirmPasswordInputField(
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 16),
                TermsCheckbox(
                  value: _agreedToTerms,
                  onChanged: (isChecked) {
                    setState(() {
                      _agreedToTerms = isChecked;
                    });
                  },
                ),
                const SizedBox(height: 32),
                CreateAccountButton(onPressed: _handleCreateAccount),
                const SizedBox(height: 16),
                const LoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
