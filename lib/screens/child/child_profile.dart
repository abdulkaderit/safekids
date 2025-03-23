import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

// class ChildProfile extends StatefulWidget {
//   @override
//   _ChildProfileState createState() => _ChildProfileState();
// }
//
// class _ChildProfileState extends State<ChildProfile> {
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   String? backgroundPicUrl;
//   String? profilePicUrl;
//   String? coverImageUrl;
//   String? email;
//   bool isEditing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   Future<void> _loadProfileData() async {
//     var userDoc = await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).get();
//     if (userDoc.exists) {
//       setState(() {
//         profilePicUrl = userDoc['profilePicture'];
//         coverImageUrl = userDoc['coverImage'];
//         _fullNameController.text = userDoc['fullName'] ?? "Your Name";
//         _phoneNumberController.text = userDoc['phoneNumber'] ?? '';
//         email = _auth.currentUser!.email ?? "Not Available";
//       });
//     }
//   }
//
//   Future<void> _pickAndCropImage(bool isBackground) async {
//     final picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;
//
//     File selectedFile = File(pickedFile.path);
//
//     // Crop the image
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: selectedFile.path,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Edit Image',
//           toolbarColor: Colors.blue,
//           toolbarWidgetColor: Colors.white,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(
//           title: 'Edit Image',
//         ),
//       ],
//     );
//
//     if (croppedFile == null) return;
//
//     File imageFile = File(croppedFile.path);
//
//     String filePath = isBackground
//         ? 'background_pictures/${_auth.currentUser!.uid}.jpg'
//         : 'profile_pictures/${_auth.currentUser!.uid}.jpg';
//
//     try {
//       TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
//       String imageUrl = await uploadTask.ref.getDownloadURL();
//
//       await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).update({
//         isBackground ? 'backgroundPicture' : 'profilePicture': imageUrl
//       });
//
//       print("Upload successful: $imageUrl");
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).update({
//       'fullName': _fullNameController.text,
//       'phoneNumber': _phoneNumberController.text
//     });
//     setState(() {
//       isEditing = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () => _pickAndCropImage(false),
//               child: Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   image: coverImageUrl != null
//                       ? DecorationImage(image: NetworkImage(coverImageUrl!), fit: BoxFit.cover)
//                       : null,
//                   color: Colors.grey[300],
//                 ),
//                 child: coverImageUrl == null
//                     ? Center(child: Text("Tap to add cover image", style: TextStyle(color: Colors.grey[700])))
//                     : null,
//               ),
//             ),
//             Positioned(
//               top: 100,
//               left: MediaQuery.of(context).size.width / 2 - 50,
//               child: GestureDetector(
//                 onTap: () => _pickAndCropImage(true),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
//                   child: profilePicUrl == null ? Icon(Icons.person, size: 50) : null,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(labelText: "Full Name"),
//                 enabled: isEditing,
//               ),
//               trailing: IconButton(
//                 icon: Icon(isEditing ? Icons.check : Icons.edit),
//                 onPressed: () {
//                   if (isEditing) _updateProfile();
//                   setState(() {
//                     isEditing = !isEditing;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: _phoneNumberController,
//                 decoration: InputDecoration(labelText: "Phone Number (Optional)"),
//                 enabled: isEditing,
//               ),
//             ),
//             ListTile(
//               title: Text("Email: $email"),
//               subtitle: Text("This cannot be changed."),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChildProfile extends StatefulWidget {
  @override
  _ChildProfileState createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? profilePicUrl;
  String? coverImageUrl;
  String? email;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    var userDoc = await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        profilePicUrl = userDoc['profilePicture'];
        coverImageUrl = userDoc['coverImage'];
        _fullNameController.text = userDoc['fullName'] ?? "Your Name";
        _phoneNumberController.text = userDoc['phoneNumber'] ?? '';
        email = _auth.currentUser!.email ?? "Not Available";
      });
    }
  }

  Future<void> _pickAndCropImage(bool isBackground) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File selectedFile = File(pickedFile.path);

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedFile.path,
      aspectRatio: isBackground ? CropAspectRatio(ratioX: 16, ratioY: 9) : CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Edit Image',
        ),
      ],
    );

    if (croppedFile == null) return;

    File imageFile = File(croppedFile.path);

    String filePath = isBackground
        ? 'background_pictures/${_auth.currentUser!.uid}.jpg'
        : 'profile_pictures/${_auth.currentUser!.uid}.jpg';

    try {
      TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).update({
        isBackground ? 'coverImage' : 'profilePicture': imageUrl
      });

      setState(() {
        if (isBackground) {
          coverImageUrl = imageUrl;
        } else {
          profilePicUrl = imageUrl;
        }
      });

      print("Upload successful: $imageUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance.collection('children').doc(_auth.currentUser!.uid).update({
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneNumberController.text
    });
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () => _pickAndCropImage(true),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: coverImageUrl != null
                            ? DecorationImage(image: NetworkImage(coverImageUrl!), fit: BoxFit.cover)
                            : null,
                        color: Colors.grey[300],
                      ),
                      child: coverImageUrl == null
                          ? Center(child: Text("Tap to add cover image", style: TextStyle(color: Colors.grey[700])))
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: GestureDetector(
                      onTap: () => _pickAndCropImage(false),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                        child: profilePicUrl == null
                            ? Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    right: MediaQuery.of(context).size.width / 2 - 90,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _pickAndCropImage(false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60), // Space for the profile picture
              ListTile(
                title: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: "Full Name"),
                  enabled: isEditing,
                ),
                trailing: IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (isEditing) _updateProfile();
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              ),
              ListTile(
                title: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: "Phone Number (Optional)"),
                  enabled: isEditing,
                ),
              ),
              ListTile(
                title: Text("Email: $email"),
                subtitle: Text("This cannot be changed."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




