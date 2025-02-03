import 'usefull/imports.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.loading);
      print('Starting Google Sign-In...');

      final result = await AuthService.instance.signInWithGoogle();
      print('Google Sign-In result: $result');

      String email;
      if (result['isNewUser'] == true) {
        email = result['email'];
        print('New user detected: $email');
      } else {
        email = result['userCredential'].user!.email!;
        print('Existing user detected: $email');
      }

      if (result['isNewUser'] != true) {
        setState(() => stateOnlyCustomIndicatorText = ButtonState.idle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In successful: $email'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        print('Navigating to HomeScreen...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() => stateOnlyCustomIndicatorText = ButtonState.success);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: You need to sign up first.'),
            backgroundColor: Colors.red,
          ),
        );
        print('Navigating to SignUpScreen...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      }
    } catch (e) {
      print('Google Sign-In error: $e');
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onPressedCustomIndicatorButton() {
    _login();
    setState(() {
      switch (stateOnlyCustomIndicatorText) {
        case ButtonState.idle:
          stateOnlyCustomIndicatorText = ButtonState.loading;
          break;
        case ButtonState.loading:
          stateOnlyCustomIndicatorText = ButtonState.fail;
          break;
        case ButtonState.fail:
          stateOnlyCustomIndicatorText = ButtonState.idle;
          break;
        case ButtonState.success:
          stateOnlyCustomIndicatorText = ButtonState.success;
          break;
      }
    });
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
                    Container(
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
                      margin: EdgeInsets.only(bottom: 3),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'username',
                          suffixIcon: Icon(Icons.person),
                          border: InputBorder.none,
                          fillColor: const Color.fromARGB(197, 110, 226, 255),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 4.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
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
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'password',
                          suffixIcon: Icon(Icons.lock),
                          border: InputBorder.none,
                          fillColor: const Color.fromARGB(197, 110, 226, 255),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 4.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ProgressButton(
                        stateWidgets: {
                          ButtonState.idle: Text(
                            "Login",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 238, 217, 214),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ButtonState.loading: Text(
                            "Loading",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ButtonState.fail: Text(
                            "Fail",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ButtonState.success: Text(
                            "Success",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        },
                        progressIndicator: CircularProgressIndicator(
                          backgroundColor:
                              const Color.fromARGB(255, 253, 253, 253),
                          valueColor: AlwaysStoppedAnimation(
                            const Color.fromARGB(255, 5, 1, 0),
                          ),
                          strokeWidth: 1,
                        ),
                        stateColors: {
                          ButtonState.idle:
                              const Color.fromARGB(255, 0, 4, 255),
                          ButtonState.loading:
                              const Color.fromARGB(255, 105, 49, 196),
                          ButtonState.fail: Colors.red.shade300,
                          ButtonState.success: Colors.green.shade400,
                        },
                        onPressed: onPressedCustomIndicatorButton,
                        state: stateOnlyCustomIndicatorText,
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SignInButton(
                        Buttons.google,
                        onPressed: () {
                          try {
                            signInWithGoogle();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google Sign-In failed: $e'),
                              ),
                            );
                          }
                        },
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

  _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format,ትክክለኛ ኢሜል አላስገቡ')),
      );
      setState(() => stateOnlyCustomIndicatorText = ButtonState.fail);
      return;
    }

    try {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.loading);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        setState(() => stateOnlyCustomIndicatorText = ButtonState.success);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful,አረጋግጠዋል! $email')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.fail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login failed: ${e.message}cheak your network or password and email,የይለፍ ቃልዎን አይተው ድግም ይሞክሩ')),
      );
      return;
    } catch (e) {
      setState(() => stateOnlyCustomIndicatorText = ButtonState.fail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}
