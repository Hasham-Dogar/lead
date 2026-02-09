import 'package:flutter/material.dart';
import 'package:leads/screens/login/widgets/email_input_field.dart';
import 'package:leads/screens/login/widgets/forgot_password_link.dart';
import 'package:leads/screens/login/widgets/login_header.dart';
import 'package:leads/screens/login/widgets/password_input_field.dart';
import 'package:leads/screens/login/widgets/sign_in_button.dart';
import 'package:leads/screens/login/widgets/signup_link.dart';
import 'package:leads/screens/choose_role/choose_role_page.dart'; // Required for navigation

part 'login_page_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}
