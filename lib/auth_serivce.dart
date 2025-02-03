import 'usefull/imports.dart';

class AuthService {
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  static AuthService get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: ['email'],
  );

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? "Error during sign-in.",
      );
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? "Error during sign-up.",
      );
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null)
        throw FirebaseAuthException(
            code: "CANCELLED", message: "Google Sign-In was canceled.");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      return {
        'isNewUser': isNewUser,
        'userCredential': userCredential,
        'email': googleUser.email,
      };
    } catch (e) {
      debugPrint("Google Sign-In error: $e");
      throw FirebaseAuthException(
          code: "GOOGLE_SIGN_IN_FAILED",
          message: "Google Sign-In failed. Please try again.");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Sign-out error: $e");
      throw FirebaseAuthException(
          code: "SIGN_OUT_FAILED", message: "Error signing out.");
    }
  }

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
