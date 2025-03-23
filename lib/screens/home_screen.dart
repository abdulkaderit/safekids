import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_log.dart';
import '../models/child_device.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Controls'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person,size: 30,color: Colors.green),
            onPressed: () {
              Navigator.of(context).pushNamed('/ParentProfile');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('parents')
            .doc(user.uid)
            .collection("children")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChildDevice> devices = [];

          for (var childDoc in snapshot.data!.docs) {
            var childData = childDoc.data() as Map<String, dynamic>;
            String childId = childDoc.id;

            devices.add(
              ChildDevice(
                childName: childData["name"],
                deviceName: childData["deviceName"] ?? "Unknown Device",
                isOnline: childData["isOnline"] ?? false,
                profilePictureUrl: childData["profilePictureUrl"],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ...devices.map((device) => _buildChildCard(context, device)),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 16),
              _buildActivitySection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, ChildDevice device) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: device.profilePictureUrl != null && device.profilePictureUrl!.isNotEmpty
              ? NetworkImage(device.profilePictureUrl!)
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        title: Text(device.childName),
        subtitle: Text("Device: ${device.deviceName}"),
        trailing: Icon(
          Icons.circle,
          color: device.isOnline ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.lock_clock, "Screen Time", () {
                  Navigator.of(context).pushNamed('/screen-time');
                }),
                _buildActionButton(Icons.block, "Block Apps", () {
                  Navigator.of(context).pushNamed('/block-apps');
                }),
                _buildActionButton(Icons.location_on, "Location", () {
                  Navigator.of(context).pushNamed('/location-tracking');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text("No User Logged In"));

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("parents")
          .doc(user.uid)
          .collection('activity_logs')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var activities = snapshot.data!.docs.map((doc) {
          return ActivityLog(
            icon: Icons.notifications, // Default icon
            title: doc['title'],
            timeAgo: doc['timeAgo'],
          );
        }).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return ListTile(
                      leading: Icon(activity.icon),
                      title: Text(activity.title),
                      subtitle: Text(activity.timeAgo),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

