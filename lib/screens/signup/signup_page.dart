import 'package:flutter/material.dart';
import 'package:leads/data/user_session_store.dart';
import 'package:leads/screens/signup/signup_page_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.selectedRole = UserRole.member});

  final UserRole selectedRole;

  @override
  State<SignupPage> createState() => SignupPageState();
}
