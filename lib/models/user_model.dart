import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  final String id;
  final String name;
  final List<String> subjects;
  final LatLng location;
  final String profileImageUrl;

  final bool isOnline;
  final DateTime lastSeen;

  const User({
    required this.id,
    required this.name,
    required this.subjects,
    required this.location,
    required this.profileImageUrl,
    this.isOnline = false,
    required this.lastSeen,
  });

  // Helper method to get subjects as comma-separated string
  String getSubjectsString() {
    return subjects.join(', ');
  }
}