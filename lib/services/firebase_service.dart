import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<List<String>> getBlockedApps(String childID) async {
    try {
      DocumentSnapshot childDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(childID)
          .get();

      if (!childDoc.exists || childDoc.data() == null) {
        print("No blocked apps found for child: $childID");
        return [];
      }

      Map<String, dynamic>? data = childDoc.data() as Map<String, dynamic>?;

      if (data == null || !data.containsKey("blockedApps")) {
        print("Blocked apps list not found.");
        return [];
      }

      return List<String>.from(data["blockedApps"]);
    } catch (e) {
      print("Error fetching blocked apps: $e");
      return [];
    }
  }
}
