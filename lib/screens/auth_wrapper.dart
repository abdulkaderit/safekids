import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safekids/screens/parent/parent_dashboard.dart';
import 'package:safekids/screens/role_selection_screen.dart';

import 'child/child_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> getHomeScreen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return RoleSelectionScreen();

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    String role = userDoc["role"];

    return role == "parent" ? ParentDashboard() : ChildDashboard(childID: '',);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getHomeScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data!;
      },
    );
  }
}