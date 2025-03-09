import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/forgot_password.dart';
import '../widgets/alert_dialog.dart';
import 'dashbord_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLogin = true;
  bool _isLoading = false;

  String? _validateInputs() {
    if (!_isLogin && _nameController.text.trim().isEmpty) {
      return "Please enter your name";
    }
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      return "Please enter a valid email";
    }
    if (_passwordController.text.trim().length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      print(" Authentication started...");
    });
    try {
      String? validationError = _validateInputs();
      if (validationError != null) {
        DialogUtils.showErrorDialog(context, validationError);
        setState(() => _isLoading = false);
        return;
      }

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      print(" Email: $email");
      print(" Password: ${'*' * password.length}");

      User? user;
      if (_isLogin) {
        print(" Logging in...");
        user = await _authService.signInWithEmail(email, password);
      } else {
        print(" Signing up...");
        user = await _authService.signUpWithEmail(name, email, password);
      }

      print(" User authentication status: ${user != null}");

      if (user !=null) {
        if(mounted){
          setState(() {
            _isLoading = false;
            print(" Authentication successful! Navigating to Dashboard...");
          });
          setState(() => _isLoading = false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
        print(" Authentication failed! Showing error dialog.");
        DialogUtils.showErrorDialog(context, 'Authentication failed!');
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print(" Error during authentication: $e");
      DialogUtils.showErrorDialog(context, 'Error: ${e.toString()}');
    }

  }

  Future<void> _signInWithGoogle() async {
     User? user = await _authService.signInWithGoogle();
     if (user != null) {
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
     }
   }

  void _navigateToForgotPasswordScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Icon(Icons.family_restroom, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                _isLogin ? 'Welcome Back' : 'Create Account',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              if (!_isLogin) ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16), // Ensure spacing
              ],

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 2),
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPasswordScreen,
                    child: const Text('Forgot Password?'),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _authenticate,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16), backgroundColor: Colors.blue),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.blue)
                    : Text(
                  _isLogin ? 'Login' : 'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.white70,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, size: 34, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('Sign in with Google'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                  });
                  print('Is Login: $_isLogin'); // Debugging
                },
                child: RichText(
                  text: TextSpan(
                    text: _isLogin ? 'Don\'t have an account? ' : 'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: _isLogin ? 'Sign Up' : 'Login',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
