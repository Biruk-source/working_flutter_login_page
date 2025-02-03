import 'usefull/imports.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<UserCredential?> signUpWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw "Google Sign-In was canceled.";
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential;
  } catch (e) {
    print("Google Sign-Up Error: $e");
    throw "An error occurred during Google Sign-Up: $e";
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email format'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create the user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'phoneNumber': phoneNumber,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-Up successful: ${userCredential.user!.email}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-Up failed: ${e.message}'),
          backgroundColor: Colors.red,
          behavior: e.message ==
                  'The email address is already in use by another account.'
              ? SnackBarBehavior.fixed
              : SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: const Color.fromARGB(249, 252, 208, 11),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              Container(
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 245, 216),
                  border: Border.all(
                    color: const Color.fromARGB(167, 115, 245, 9),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(
                      controller: _phoneNumberController,
                      label: 'Phone Number',
                      hint: '+251......',
                      icon: Icons.phone,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'email@example.com',
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 4, 255),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    try {
                      final UserCredential? userCredential =
                          await signUpWithGoogle();
                      if (userCredential != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Successfully registered ${userCredential.user!.email}'),
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.green,
                            behavior: userCredential.user!.email ==
                                    'The email address is already in use by another account.'
                                ? SnackBarBehavior.fixed
                                : SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red),
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    bool obscure = false,
  }) {
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
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: Icon(icon),
          border: InputBorder.none,
          fillColor: const Color.fromARGB(197, 110, 226, 255),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 4.0,
          ),
        ),
      ),
    );
  }
}
