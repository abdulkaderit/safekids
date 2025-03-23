// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:safekids/screens/parent/parent_dashboard.dart';
//
// import 'child/child_dashboard.dart'; // Child UI
//
// class SignUpScreen extends StatefulWidget {
//   final String role;
//   SignUpScreen({required this.role});
//
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _parentIDController = TextEditingController();
//
//   bool isLoading = false;
//
//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       String uid = userCredential.user!.uid;
//       String shortID = widget.role == "parent" ? _generateShortID() : "";
//
//       String linkedParentID = "";
//       if (widget.role == "child") {
//         var parentQuery = await _firestore.collection('users').where("shortID", isEqualTo: _parentIDController.text.trim()).get();
//         if (parentQuery.docs.isNotEmpty) {
//           linkedParentID = parentQuery.docs.first.id;
//         } else {
//           throw Exception("Parent ID not found");
//         }
//       }
//
//       await _firestore.collection("users").doc(uid).set({
//         "uid": uid,
//         "name": _nameController.text.trim(),
//         "email": _emailController.text.trim(),
//         "role": widget.role,
//         "shortID": shortID,
//         "linkedParentID": linkedParentID,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//
//       if (widget.role == "parent") {
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
//   String _generateShortID() {
//     return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sign Up as ${widget.role}")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Enter your name" : null,
//               ),
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
//               if (widget.role == "child")
//                 TextFormField(
//                   controller: _parentIDController,
//                   decoration: InputDecoration(labelText: "Enter Parent ID"),
//                   validator: (value) => value!.isEmpty ? "Enter Parent ID" : null,
//                 ),
//               SizedBox(height: 20),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _signUp,
//                 child: Text("Sign Up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
