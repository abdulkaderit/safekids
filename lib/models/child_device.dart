class ChildDevice {
  final String childName;
  final String deviceName;
  final bool isOnline;
  final String? profilePictureUrl;  // New field for profile picture

  ChildDevice({
    required this.childName,
    required this.deviceName,
    required this.isOnline,
    this.profilePictureUrl,
  });
}