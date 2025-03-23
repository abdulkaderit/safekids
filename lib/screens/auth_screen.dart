// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
//
//
//
// class AuthScreen extends StatefulWidget {
//   final String selectedRole;
//   AuthScreen({required this.selectedRole});
//
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController shortIdController = TextEditingController(); // For Child Signup
//
//   bool isLoading = false;
//   bool isLogin = false; // Toggle between Sign-Up and Login mode
//
//   void _authenticate() async {
//     setState(() => isLoading = true);
//
//     try {
//       if (isLogin) {
//         await AuthService().login(emailController.text, passwordController.text, context);
//       } else {
//         if (widget.selectedRole == "parent") {
//           await AuthService().createParentAccount(
//             nameController.text,
//             emailController.text,
//             passwordController.text,
//             context,
//           );
//         } else {
//           await AuthService().createChildAccount(
//             nameController.text,
//             emailController.text,
//             passwordController.text,
//             shortIdController.text, // Parent ID for child accounts
//             context,
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isLogin ? "Login" : "Sign Up")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (!isLogin) // Show Name field only for Sign-Up
//               TextField(controller: nameController,
//                   decoration: InputDecoration(labelText: "Name")),
//             TextField(controller: emailController,
//                 decoration: InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController,
//                 decoration: InputDecoration(labelText: "Password"),
//                 obscureText: true),
//             if (!isLogin && widget.selectedRole == "child") // Show Parent ID only for Child Sign-Up
//               TextField(controller: shortIdController,
//                   decoration: InputDecoration(labelText: "Enter Parent Short ID")),
//             SizedBox(height: 20),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                  onPressed: _authenticate,
//               child: Text(isLogin ? "Login" : "Sign Up"),
//             ),
//             TextButton(
//               onPressed:(){
//                 setState(()=> isLogin = !isLogin);
//                 nameController.clear();
//                 emailController.clear();
//                 passwordController.clear();
//                 shortIdController.clear();
//               },
//               child: Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safekids/screens/parent/parent_dashboard.dart';

import 'child/child_dashboard.dart';

class AuthScreen extends StatefulWidget {
  final String role;

  AuthScreen({super.key, required this.role});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLogin = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _parentIdController = TextEditingController(); // Controller for Parent ID (for children only)

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      if (isLogin) {
        // **Login User**
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
        String role = userDoc["role"];
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => role == "parent" ? ParentDashboard() : ChildDashboard(childID: userCredential.user!.uid),
        ));
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (widget.role == "child" && _parentIdController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid Parent Short ID.")));
          setState(() => _isLoading = false);
          return;
        }

        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "role": widget.role,
          "parentShortId": widget.role == "child" ? _parentIdController.text.trim() : null, // Save parent short ID for children
        });

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => widget.role == "parent" ? ParentDashboard() : ChildDashboard(childID: userCredential.user!.uid),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      _isLoading = false; // Stop loading
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.family_restroom, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (!isLogin)
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                    ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) => value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) => value!.length < 6 ? "Password must be 6+ chars" : null,
                  ),
                  const SizedBox(height: 8),
                  if (widget.role == "child") // Only show parent ID field for child role
                    TextFormField(
                      controller: _parentIdController,
                      decoration: InputDecoration(labelText: "Parent Short ID"),
                      validator: (value) => value!.isEmpty ? "Please enter your parent's Short ID" : null,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _authenticate,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child:_isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ) :Text(isLogin ? "Login" : "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin= !isLogin;
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    child: RichText(
                        text: TextSpan(
                          text: isLogin? 'Don\'t have an account? ' : 'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: isLogin? 'Sign Up' : 'Login',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.green,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

