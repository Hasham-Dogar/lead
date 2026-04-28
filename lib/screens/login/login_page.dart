import 'package:flutter/material.dart';
import 'package:leads/screens/login/widgets/email_input_field.dart';
import 'package:leads/screens/login/widgets/forgot_password_link.dart';
import 'package:leads/screens/login/widgets/login_header.dart';
import 'package:leads/screens/login/widgets/password_input_field.dart';
import 'package:leads/screens/login/widgets/sign_in_button.dart';
import 'package:leads/screens/login/widgets/signup_link.dart';
import 'package:leads/data/user_session_store.dart';
import 'package:leads/screens/home/home_page.dart';
import 'package:leads/screens/team_manager_home/team_manager_home_page.dart';

part 'login_page_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}
