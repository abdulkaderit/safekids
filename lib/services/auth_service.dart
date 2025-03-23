// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//   Future<void> logout() async {
//     await _auth.signOut();
//   }
//
//   bool isPasswordStrong(String password) {
//     return password.length >= 8 && // Minimum 8 characters
//         RegExp(r'[A-Z]').hasMatch(password) && // At least one uppercase
//         RegExp(r'[a-z]').hasMatch(password) && // At least one lowercase
//         RegExp(r'[0-9]').hasMatch(password) && // At least one digit
//         RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password); // At least one special character
//   }
//
//   bool isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }
//
//   bool isUserAuthenticated() {
//     return FirebaseAuth.instance.currentUser != null;
//   }
//
//
//   Future<String?> getUserRole(String uid) async {
//     DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//     if (doc.exists) {
//       return doc['role'];
//     }
//     return null;
//   }
//
//   // Future<void> createParentAccount(String name, String email, String password, BuildContext context) async {
//   //   try {
//   //
//   //     if (!isPasswordStrong(password)) {
//   //       print("Weak password");
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Password must be at least 8 characters, include upper/lowercase, a number, and a special character.")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     // Check if email already exists
//   //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     String userId = userCredential.user!.uid;
//   //     String shortId = generateShortId();
//   //
//   //     await _firestore.collection("parents").doc(userId).set({
//   //       "name": name,
//   //       "email": email,
//   //       "role": "parent",
//   //       "parentId": userId,
//   //       "shortId": shortId, // Unique Short ID
//   //       "createdAt": FieldValue.serverTimestamp(),
//   //     });
//   //
//   //     // Navigate to Parent Dashboard
//   //     _navigateToDashboard(context, "parent");
//   //   } on FirebaseAuthException catch (e) {
//   //     if (e.code == 'email-already-in-use') {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("This email is already registered.")),
//   //       );
//   //     } else {
//   //       print("Error creating parent account: ${e.message}");
//   //     }
//   //   } catch (e) {
//   //     print("Unexpected error: $e");
//   //   }
//   // }
//   // Future<void> createChildAccount(String name, String email, String password, String shortId, BuildContext context) async {
//   //   try {
//   //     // Reload the current user to make sure Firebase state is updated
//   //     await FirebaseAuth.instance.currentUser?.reload();
//   //
//   //     // Adding a small delay to ensure the reload has finished
//   //     await Future.delayed(Duration(seconds: 4));
//   //
//   //     final user = FirebaseAuth.instance.currentUser;
//   //     print("After reload, current user: $user");
//   //
//   //     if (user == null || !isUserAuthenticated()) {
//   //       print("User still not authenticated after reload. Exiting function.");
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("User authentication failed, please log in again.")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     // Validate Parent Short ID
//   //     QuerySnapshot parentQuery = await _firestore.collection("parents")
//   //         .where("shortId", isEqualTo: shortId)
//   //         .limit(1)
//   //         .get();
//   //
//   //     if (parentQuery.docs.isEmpty) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Invalid Parent ID")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     // Get parent ID
//   //     String parentId = parentQuery.docs.first.id;
//   //
//   //     // Check if child already exists
//   //     QuerySnapshot existingChild = await _firestore.collectionGroup("children")
//   //         .where("email", isEqualTo: email)
//   //         .limit(1)
//   //         .get();
//   //
//   //     if (existingChild.docs.isNotEmpty) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Child account already exists")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     if (!isPasswordStrong(password)) {
//   //       print("Weak password");
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Password must be at least 8 characters, include upper/lowercase, a number, and a special character.")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     // Create child account in Firebase Authentication
//   //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     String childId = userCredential.user!.uid;
//   //     print("Child account created with ID: $childId");
//   //
//   //     // Store child details under the parent
//   //     await _firestore.collection("parents").doc(parentId).collection("children").doc(childId).set({
//   //       "name": name,
//   //       "email": email,
//   //       "role": "child",
//   //       "deviceName": "Child's Device",
//   //       "isOnline": true,
//   //       "parentId": parentId,
//   //       "createdAt": FieldValue.serverTimestamp(),
//   //     });
//   //
//   //     print("Child added successfully!");
//   //
//   //     // Navigate to Child Dashboard
//   //     _navigateToDashboard(context, "child");
//   //   } catch (e) {
//   //     print("Error creating child account: $e");
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Error creating child account: $e")),
//   //     );
//   //   }
//   // }
//   // Future<void> login(String email, String password, BuildContext context) async {
//   //   try {
//   //     if (!isValidEmail(email)) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text("Please enter a valid email address.")),
//   //       );
//   //       return;
//   //     }
//   //
//   //     // Sign in with Firebase Authentication
//   //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     String userId = userCredential.user!.uid;
//   //     print(" User logged in with ID: $userId");
//   //
//   //     // Run both queries in parallel for better performance
//   //     var parentFuture = _firestore.collection("parents").doc(userId).get();
//   //     var childFuture = _firestore.collection("children").where("userId", isEqualTo: userId).limit(1).get();
//   //
//   //     // Wait for both results
//   //     var parentSnapshot = await parentFuture;
//   //     var childSnapshot = await childFuture;
//   //
//   //     if (parentSnapshot.exists) {
//   //       print("User is a Parent");
//   //       _navigateToDashboard(context, "parent");
//   //       return;
//   //     }
//   //
//   //     if (childSnapshot.docs.isNotEmpty) {
//   //       print(" User is a Child");
//   //       _navigateToDashboard(context, "child");
//   //       return;
//   //     }
//   //
//   //     print(" No role found for user");
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text("No account found. Please contact support.")),
//   //     );
//   //   } catch (e) {
//   //     print(" Login failed: $e");
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Login failed. Please check your credentials.")),
//   //     );
//   //   }
//   // }
//
//   Future<void> createParentAccount(String name, String email, String password, BuildContext context) async {
//     try {
//       if (!isPasswordStrong(password)) {
//         print("Weak password");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Password must be at least 8 characters, include upper/lowercase, a number, and a special character.")),
//         );
//         return;
//       }
//
//       // Create Firebase Authentication user
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       String userId = userCredential.user!.uid;
//
//       // Generate a short ID for the parent
//       String shortId = generateShortId();
//
//       // Store parent data in Firestore
//       await _firestore.collection("parents").doc(userId).set({
//         "name": name,
//         "email": email,
//         "role": "parent",
//         "parentId": userId,
//         "shortId": shortId,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//
//       // Notify the user that the parent account has been created
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Parent account created!")),
//       );
//
//       // Navigate to the Parent Dashboard after successful account creation
//       Navigator.pushReplacementNamed(context, '/parentDashboard');
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This email is already registered.")));
//       } else {
//         print("Error creating parent account: ${e.message}");
//       }
//     } catch (e) {
//       print("Unexpected error: $e");
//     }
//   }
//
//
//   Future<void> createChildAccount(String name, String email, String password, String shortId, BuildContext context) async {
//     try {
//       // Validate Parent Short ID
//       QuerySnapshot parentQuery = await _firestore.collection("parents")
//           .where("shortId", isEqualTo: shortId)
//           .limit(1)
//           .get();
//
//       if (parentQuery.docs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Parent ID")));
//         return;
//       }
//
//       // Create the child account
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       String childId = userCredential.user!.uid;
//
//       // Store child data in Firestore, associating it with the parent via shortId
//       String parentId = parentQuery.docs.first.id;
//
//       await _firestore.collection("parents")
//           .doc(parentId)
//           .collection("children")
//           .doc(childId)
//           .set({
//         "name": name,
//         "email": email,
//         "role": "child",
//         "parentShortId": shortId,  // Store parent's shortId in the child document
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//
//       // Optionally, navigate to the child dashboard
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Child account created!")));
//
//     } catch (e) {
//       print("Error creating child account: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating child account: $e")));
//     }
//   }
//
//
//   Future<void> login(String email, String password, BuildContext context) async {
//     try {
//       // Sign in with Firebase Authentication
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       String userId = userCredential.user!.uid;
//
//       // Check if the user is a parent or child
//       DocumentSnapshot parentSnapshot = await _firestore.collection("parents").doc(userId).get();
//       if (parentSnapshot.exists) {
//         print("User is a Parent");
//         // Navigate to Parent Dashboard
//         _navigateToDashboard(context, "parent");
//       } else {
//         // Check if the user is a child under any parent
//         QuerySnapshot childSnapshot = await _firestore.collection("parents").where("shortId", isEqualTo: userId).get();
//
//         if (childSnapshot.docs.isNotEmpty) {
//           print("User is a Child");
//           // Navigate to Child Dashboard
//           _navigateToDashboard(context, "child");
//         } else {
//           print("No role found for user");
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No account found. Please contact support.")));
//         }
//       }
//     } catch (e) {
//       if (e is FirebaseAuthException && e.code == 'network-request-failed') {
//         print("Network error occurred. Please check your connection and try again.");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Network error. Please check your connection and try again.")));
//       } else {
//         print("Login failed: $e");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed. Please check your credentials.")));
//       }
//     }
//   }
//
//
//
//   void _navigateToDashboard(BuildContext context, String role) {
//     Future.delayed(Duration(milliseconds: 50), () {
//       Navigator.pushReplacementNamed(context, role == "parent" ? "/parentDashboard" : "/childDashboard");
//     });
//   }
//
//   String generateShortId() {
//     final random = Random.secure();
//     final bytes = List<int>.generate(6, (i) => random.nextInt(256));
//     final base64 = base64Url.encode(bytes);
//     return base64.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').substring(0, 6);
//   }
// }
//
