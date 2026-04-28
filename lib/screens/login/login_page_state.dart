part of 'login_page.dart';

class LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate email and password
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
      return;
    }

    // Simple email validation
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
      return;
    }

    // Validate password length
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
      return;
    }

    final session = UserSessionStore.instance;
    if (session.hasRegisteredUsers) {
      final isValidUser = session.loginWithStoredCredentials(
        email: email,
        password: password,
      );

      if (!isValidUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Color(0xFFFC6060),
          ),
        );
        return;
      }
    }

    // Show loading state
    setState(() {
      _isLoading = true;
    });

    // Simulate login delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (session.role == UserRole.teamManager) {
          final showNoPlanDialog = !session.hasActivePaidPlan;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TeamManagerHomePage(
                showPlanActivationDialog: showNoPlanDialog,
              ),
            ),
          );
          return;
        }

        final shouldShowUnassignedDialog =
            session.role == UserRole.member && !session.isMemberAssignedToTeam;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                HomePage(showTeamAssignmentDialog: shouldShowUnassignedDialog),
          ),
        );
      }
    });
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
                const LoginHeader(),
                const SizedBox(height: 32),
                EmailInputField(controller: _emailController),
                const SizedBox(height: 24),
                PasswordInputField(controller: _passwordController),
                const SizedBox(height: 12),
                const ForgotPasswordLink(),
                const SizedBox(height: 32),
                SignInButton(isLoading: _isLoading, onPressed: _handleLogin),
                const SizedBox(height: 24),
                const SignupLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
