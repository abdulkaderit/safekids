import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ParentProfile extends StatefulWidget {
  @override
  _ParentProfileState createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  final _auth = FirebaseAuth.instance;
  String? profilePicUrl;
  String? backgroundPicUrl;
  String? parentName;
  String? shortId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _fetchParentData();
  }

  Future<void> _fetchParentData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("parents").doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        shortId = doc["shortId"];
        parentName = doc["name"];
        isLoading = false;
      });
    } else {
      print("Parent data not found!");
    }
  }

  Future<void> _loadProfileData() async {
    var userDoc = await FirebaseFirestore.instance.collection('parents').doc(_auth.currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        profilePicUrl = userDoc['profilePicture'];
        backgroundPicUrl = userDoc['backgroundPicture'];
        parentName = userDoc["name"] ?? "Parent";
        shortId = userDoc["shortId"] ?? "N/A";
      });
    }
  }

  Future<void> _pickImage(bool isBackground) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String filePath = isBackground
        ? 'background_pictures/${_auth.currentUser!.uid}.jpg'
        : 'profile_pictures/${_auth.currentUser!.uid}.jpg';

    try {
      TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('parents').doc(_auth.currentUser!.uid).update({
        isBackground ? 'backgroundPicture' : 'profilePicture': imageUrl
      });

      setState(() {
        if (isBackground) {
          backgroundPicUrl = imageUrl;
        } else {
          profilePicUrl = imageUrl;
        }
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  void _logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmLogout) {
      await _auth.signOut();
      // Redirect to the sign-in page
      Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile",style: TextStyle(fontSize: 18,color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Cover Image with Edit Icon
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: backgroundPicUrl != null
                            ? DecorationImage(image: NetworkImage(backgroundPicUrl!), fit: BoxFit.cover)
                            : null,
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          if (backgroundPicUrl == null)
                            Positioned(
                              top: 24,
                              left: 125,
                              child: Text(
                                "Tap to add cover image",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _pickImage(true),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Profile Picture with Edit Icon
                  Positioned(
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                            child: profilePicUrl == null
                                ? Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 20,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Space for the profile picture
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Name: ${parentName?? "Parent"}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Email: ${_auth.currentUser?.email ?? "Unknown"}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Short ID: $shortId",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () => Navigator.of(context).pushNamed('/settings'),
              ),
              ListTile(
                leading: Icon(Icons.device_hub),
                title: Text("Device Settings"),
                onTap: () => Navigator.pushNamed(context, "/device-settings"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

