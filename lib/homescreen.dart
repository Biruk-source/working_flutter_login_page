import 'usefull/imports.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService.instance.signOut();

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: const Color.fromARGB(249, 252, 208, 11),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context), // Call sign-out function
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
