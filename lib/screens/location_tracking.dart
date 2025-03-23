import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _locationTrackingEnabled = true;
  bool _geofencingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMapPreview(),
          const SizedBox(height: 16),
          _buildLocationSettings(),
          const SizedBox(height: 16),
          _buildSafeZonesCard(),
          const SizedBox(height: 16),
          _buildLocationHistoryCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add safe zone
        },
        icon: const Icon(Icons.add_location),
        label: const Text('Add Safe Zone'),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Card(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text('Map will be displayed here'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 6,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('123 School Street'),
                    ],
                  ),
                ),
                Text(
                  '2 min ago',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSettings() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Location Tracking'),
            subtitle: const Text('Track device location in real-time'),
            value: _locationTrackingEnabled,
            onChanged: (value) {
              setState(() {
                _locationTrackingEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Geofencing'),
            subtitle: const Text('Get alerts when entering/leaving safe zones'),
            value: _geofencingEnabled,
            onChanged: (value) {
              setState(() {
                _geofencingEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSafeZonesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Safe Zones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSafeZoneTile(
              'School',
              'Active now',
              Icons.school,
              Colors.blue,
            ),
            _buildSafeZoneTile(
              'Home',
              'Last visit: 2 hours ago',
              Icons.home,
              Colors.green,
            ),
            _buildSafeZoneTile(
              'Grandma\'s House',
              'Last visit: Yesterday',
              Icons.house,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafeZoneTile(
      String name,
      String status,
      IconData icon,
      Color color,
      ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(name),
      subtitle: Text(status),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // TODO: Implement edit safe zone
        },
      ),
    );
  }

  Widget _buildLocationHistoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Show full history
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLocationHistoryTile(
              'Arrived at School',
              '8:30 AM',
              Icons.school,
            ),
            _buildLocationHistoryTile(
              'Left Home',
              '8:00 AM',
              Icons.home,
            ),
            _buildLocationHistoryTile(
              'Arrived at Home',
              'Yesterday 6:00 PM',
              Icons.house,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationHistoryTile(
      String event,
      String time,
      IconData icon,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(event),
      subtitle: Text(time),
      trailing: IconButton(
        icon: const Icon(Icons.map),
        onPressed: () {
          // TODO: Show location on map
        },
      ),
    );
  }
}