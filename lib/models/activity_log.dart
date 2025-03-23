import 'package:flutter/cupertino.dart';

class ActivityLog {
  final IconData icon;
  final String title;
  final String timeAgo;

  ActivityLog({
    required this.icon,
    required this.title,
    required this.timeAgo,
  });
}