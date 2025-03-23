import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class BlockAppsScreen extends StatefulWidget {
  final String childID;

  BlockAppsScreen({required this.childID});

  @override
  _BlockAppsScreenState createState() => _BlockAppsScreenState();
}

class _BlockAppsScreenState extends State<BlockAppsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> allApps = [
    "com.facebook.katana",
    "com.instagram.android",
    "com.tiktok.android",
    "com.snapchat.android",
    "com.whatsapp",
    "com.youtube.android"
  ];
  List<String> blockedApps = [];
  Map<String, int> appTimeLimits = {};
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _listenForChanges();
  }

  // 🔴 **Real-time Listener for Blocked Apps & Time Limits**
  void _listenForChanges() {
    _firestore.collection("users").doc(widget.childID).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          blockedApps = List<String>.from(snapshot.data()?["blockedApps"] ?? []);
          appTimeLimits = Map<String, int>.from(snapshot.data()?["appTimeLimits"] ?? {});
        });
      }
    });
  }

  // 🔴 **Update Blocked Apps in Firestore**
  Future<void> _updateBlockedApps() async {
    try {
      await _firestore.collection("users").doc(widget.childID).update({"blockedApps": blockedApps});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blocked apps updated!")));
    } catch (e) {
      print("Error updating blocked apps: $e");
    }
  }

  // 🔴 **Update App Time Limits in Firestore**
  Future<void> _updateAppTimeLimits(String app, int time) async {
    try {
      setState(() {
        appTimeLimits[app] = time;
      });
      await _firestore.collection("users").doc(widget.childID).update({"appTimeLimits": appTimeLimits});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Time limit updated!")));
    } catch (e) {
      print("Error updating time limits: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredApps = allApps
        .where((app) => app.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Manage App Blocking")),
      body: Column(
        children: [
          // 🔴 **Search Bar for Apps**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search apps...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🔴 **List of Apps with Blocking & Time Limits**
          Expanded(
            child: ListView.builder(
              itemCount: filteredApps.length,
              itemBuilder: (context, index) {
                String app = filteredApps[index];
                return ListTile(
                  leading: Icon(Icons.apps),
                  title: Text(app),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔴 **Time Limit Selector**
                      IconButton(
                        icon: Icon(Icons.timer, color: Colors.blue),
                        onPressed: () => _showTimeLimitDialog(app),
                      ),

                      // 🔴 **Block/Unblock Checkbox**
                      Checkbox(
                        value: blockedApps.contains(app),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              blockedApps.add(app);
                            } else {
                              blockedApps.remove(app);
                            }
                          });
                          _updateBlockedApps();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔴 **Dialog for Setting App Time Limits**
  void _showTimeLimitDialog(String app) {
    int currentLimit = appTimeLimits[app] ?? 0;
    TextEditingController controller = TextEditingController(text: currentLimit.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set Time Limit for $app"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Time in minutes"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int newLimit = int.tryParse(controller.text) ?? 0;
                _updateAppTimeLimits(app, newLimit * 60); // Convert minutes to seconds
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

