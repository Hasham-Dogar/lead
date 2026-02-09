import 'package:flutter/material.dart';
import 'package:leads/screens/signup/signup_page.dart';
import 'package:leads/screens/signup/widgets/signup_header.dart';
import 'package:leads/screens/signup/widgets/fullname_input_field.dart';
import 'package:leads/screens/signup/widgets/signup_email_input_field.dart';
import 'package:leads/screens/signup/widgets/phone_input_field.dart';
import 'package:leads/screens/signup/widgets/signup_password_input_field.dart';
import 'package:leads/screens/signup/widgets/confirm_password_input_field.dart';
import 'package:leads/screens/signup/widgets/terms_checkbox.dart';
import 'package:leads/screens/signup/widgets/create_account_button.dart';
import 'package:leads/screens/signup/widgets/login_link.dart';

class SignupPageState extends State<SignupPage> {
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
                const FullnameInputField(),
                const SizedBox(height: 24),
                const SignupEmailInputField(),
                const SizedBox(height: 24),
                const PhoneInputField(),
                const SizedBox(height: 24),
                const SignupPasswordInputField(),
                const SizedBox(height: 24),
                const ConfirmPasswordInputField(),
                const SizedBox(height: 16),
                const TermsCheckbox(),
                const SizedBox(height: 32),
                const CreateAccountButton(),
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
