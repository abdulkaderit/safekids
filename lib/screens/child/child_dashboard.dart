import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ChildDashboard extends StatefulWidget {
  final String childID;

  ChildDashboard({required this.childID});

  @override
  _ChildDashboardState createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  List<String> blockedApps = [];
  Map<String, int> appTimeLimits = {};
  Map<String, int> usedTime = {};

  @override
  void initState() {
    super.initState();
    _listenForBlockedApps();
  }

  void _listenForBlockedApps() {
    FirebaseFirestore.instance.collection("users").doc(widget.childID).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          blockedApps = List<String>.from(snapshot.data()?["blockedApps"] ?? []);
          appTimeLimits = Map<String, int>.from(snapshot.data()?["appTimeLimits"] ?? {});
          usedTime = Map<String, int>.from(snapshot.data()?["usedTime"] ?? {});
        });
        _checkAndCloseBlockedApps();
      }
    });
  }

  void _checkAndCloseBlockedApps() async {
    for (String app in blockedApps) {
      bool isRunning = await _isAppRunning(app);
      if (isRunning) {
        _closeApp(app);
      }
    }

    // Check if any app exceeded time limit
    for (String app in appTimeLimits.keys) {
      int timeLeft = (appTimeLimits[app]! - (usedTime[app] ?? 0));
      if (timeLeft <= 0) {
        if (!blockedApps.contains(app)) {
          setState(() {
            blockedApps.add(app);
          });
          FirebaseFirestore.instance.collection("users").doc(widget.childID).update({
            "blockedApps": blockedApps,
          });
          _closeApp(app);
        }
      }
    }
  }

  Future<bool> _isAppRunning(String packageName) async {
    try {
      const platform = MethodChannel('app_blocking');
      final bool isRunning = await platform.invokeMethod('isAppRunning', {"package": packageName});
      return isRunning;
    } catch (e) {
      print("Error checking app: $e");
      return false;
    }
  }

  void _closeApp(String packageName) async {
    try {
      const platform = MethodChannel('app_blocking');
      await platform.invokeMethod('closeApp', {"package": packageName});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$packageName has been blocked!"),
      ));
    } catch (e) {
      print("Error closing app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Child Dashboard")),
      body: Center(child: Text("Listening for blocked apps...")),
    );
  }
}





