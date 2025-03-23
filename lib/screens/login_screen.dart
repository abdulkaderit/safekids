// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:safekids/screens/parent/parent_dashboard.dart';
// import 'child/child_dashboard.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   bool isLoading = false;
//
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       // Get user role from Firestore
//       DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
//       String role = userDoc["role"];
//
//       // Navigate based on role
//       if (role == "parent") {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ParentDashboard()));
//       } else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChildDashboard()));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (value) => value!.isEmpty ? "Enter your email" : null,
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: "Password"),
//                 validator: (value) => value!.length < 6 ? "Password must be 6+ chars" : null,
//               ),
//               SizedBox(height: 20),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _login,
//                 child: Text("Login"),
//               ),
//               Text("data")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
