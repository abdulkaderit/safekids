import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/child/child_dashboard.dart';
import '../screens/parent/parent_dashboard.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<User?> signUpParent(BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;
        String shortID = generateShortIDFromUUID();

        print("Generated Parent Short ID: $shortID");

        try {
          await _firestore.collection('users').doc(uid).set({
            "uid": uid,
            "name": name,
            "email": email,
            "role": "parent",
            "parentShortID": shortID,
            "createdAt": FieldValue.serverTimestamp(),
          });
          print("Firestore Write Success: Parent data saved!");
        } catch (e) {
          print("Firestore Write Error: $e");
        }

        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ParentDashboard())
          );
        }
        return user;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }


  Future<User?> signUpChild(BuildContext context, String name, String email, String password, String parentShortID) async {
    try {
      QuerySnapshot parentSnapshot = await _firestore
          .collection('users')
          .where("parentShortID", isEqualTo: parentShortID)
          .get();

      if (parentSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid Parent Short ID!"))
        );
        return null;
      }

      String parentUID = parentSnapshot.docs.first.id;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;

        await _firestore.collection('users').doc(uid).set({
          "uid": uid,
          "name": name,
          "email": email,
          "role": "child",
          "linkedParentID": parentUID,
          "createdAt": FieldValue.serverTimestamp(),
        });

        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChildDashboard(childID: uid))
          );
        }
        return user;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }


  Future<User?> loginUser(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          String role = data['role'];

          if (role == "parent") {
            if (context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ParentDashboard()));
            }
          } else if (role == "child") {
            if (context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChildDashboard(childID: user.uid)));
            }
          } else {
            print("Unknown user role: $role");
          }
          return user;
        }
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }


  String generateShortIDFromUUID() {
    var uuid = Uuid();
    return uuid.v4().substring(0, 6).toUpperCase();
  }


  Future<List<String>> getBlockedApps(String childID) async {
    try {
      DocumentSnapshot childDoc = await _firestore.collection("users").doc(childID).get();

      if (!childDoc.exists || childDoc.data() == null) {
        print(" No blocked apps found for child: $childID");
        return [];
      }

      Map<String, dynamic>? data = childDoc.data() as Map<String, dynamic>?;

      if (data == null || !data.containsKey("blockedApps")) {
        print(" Blocked apps list not found.");
        return [];
      }

      return List<String>.from(data["blockedApps"]);
    } catch (e) {
      print("Error fetching blocked apps: $e");
      return [];
    }
  }
}

