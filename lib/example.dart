class _LoginScreenState extends State<LoginScreen> {
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.loading);

      // Call the updated signInWithGoogle method
      final result = await AuthService.instance.signInWithGoogle();

      if (result['isNewUser'] == true) {
        // New user, navigate to the SignUp Screen
        setState(() => stateOnlyCustomIndicatorText = ButtonState.idle);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(),
          ),
        );
      } else {
        // Existing user, sign them in
        final userCredential = result['userCredential'];
        if (userCredential.user != null) {
          setState(() => stateOnlyCustomIndicatorText = ButtonState.success);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Google Sign-In successful: ${userCredential.user!.email}'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.fail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: const Color.fromARGB(255, 70, 15, 15),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(249, 252, 208, 11),
        actions: [Icon(Icons.info), Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 245, 216),
              border: Border.all(
                color: const Color.fromARGB(167, 115, 245, 9),
                width: 1,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      child: Lottie.asset(
                        'assets/animations/Animation - 1737998566825 (1).json',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 50),
                      child: Text(
                        'GB delivery',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AguDisplay',
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    // Email and Password Fields
                    _buildTextField(_emailController, 'Username', Icons.person),
                    _buildTextField(_passwordController, 'Password', Icons.lock,
                        isPassword: true),
                    // Login Button
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ProgressButton(
                        stateWidgets: {
                          ButtonState.idle: Text("Login"),
                          ButtonState.loading: Text("Loading"),
                          ButtonState.fail: Text("Fail"),
                          ButtonState.success: Text("Success"),
                        },
                        progressIndicator: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                          strokeWidth: 1,
                        ),
                        stateColors: {
                          ButtonState.idle: Colors.blue,
                          ButtonState.loading: Colors.purple,
                          ButtonState.fail: Colors.red.shade300,
                          ButtonState.success: Colors.green.shade400,
                        },
                        onPressed: _login,
                        state: stateOnlyCustomIndicatorText,
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    // Sign Up Button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    // Google Sign-In Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SignInButton(
                        Buttons.google,
                        onPressed: _signInWithGoogle,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        text: 'Continue with Google',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[200],
        border: Border.all(color: Colors.blue, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 7),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        ),
      ),
    );
  }
}
