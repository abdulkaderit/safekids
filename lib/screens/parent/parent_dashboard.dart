import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safekids/screens/parent/parent_profile.dart';
import '../block_apps_screen.dart';
import '../controls_screen.dart';
import '../devices_screen.dart';
import '../home_screen.dart';
import '../location_tracking.dart';
import '../settings_screen.dart';

class ParentDashboard extends StatefulWidget {
  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}
class _ParentDashboardState extends State<ParentDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String parentName = "";
  List<Map<String, dynamic>> children = [];
  int _selectedIndex = 0;
  String? shortId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchParentData();
  }

  Future<void> _fetchParentData() async
  {
    User? user = _auth.currentUser;
    if (user == null) return;

    // Fetch parent details
    DocumentSnapshot parentDoc = await _firestore.collection("users").doc(user.uid).get();
    setState(() {
      parentName = parentDoc["name"];
    });

    // Fetch linked children
    QuerySnapshot childDocs = await _firestore.collection("users").where("linkedParentID", isEqualTo: user.uid).get();
    setState(() {
      children = childDocs.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Fetch blocked apps from Firestore
  // DocumentSnapshot childDoc = await FirebaseFirestore.instance.collection("users").doc(childID).get();
  // List<String> blockedApps = List<String>.from(childDoc["blockedApps"] ?? []);
  //
  //  Check running apps (requires Android service)
  // if (blockedApps.contains(runningApp)) {
  // closeApp(runningApp); // Force stop the blocked app
  // }


  // Future<void> _fetchParentData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection("parents").doc(user.uid).get();
  //   if (doc.exists) {
  //     setState(() {
  //       shortId = doc["shortId"];
  //       parentName = doc["name"];
  //       isLoading = false;
  //     });
  //   } else {
  //     print("Parent data not found!");
  //   }
  // }

  final List<Widget> _screens = [
    const HomePageContent(),
    const DevicesScreen(),
    const ControlsScreen(),
    const LocationScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading ? Text("Loading...") : Text("Welcome, $parentName"),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed('/profile');
            }, icon: Icon(Icons.person,size: 34,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome, $parentName", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Linked Children:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(children[index]["name"]),
                      subtitle: Text(children[index]["email"]),
                      leading: Icon(Icons.child_care),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ParentProfile()));
                },
                child: Text("View Parent Profile"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BlockAppsScreen(childID: "childId")));
                },
                child: Text("Manage Blocked Apps"),
              ),

            ],
          ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.devices), label: 'Devices'),
          NavigationDestination(icon: Icon(Icons.lock_clock), label: 'Controls'),
          NavigationDestination(icon: Icon(Icons.location_on), label: 'Location'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
