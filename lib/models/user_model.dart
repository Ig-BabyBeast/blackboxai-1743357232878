import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supply_mate/constants/app_constants.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<String> subjects;
  final LatLng location;
  final String profileImageUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final int maxConnections = AppConstants.maxNearbyUsers;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.subjects,
    required this.location,
    required this.profileImageUrl,
    this.isOnline = false,
    required this.lastSeen,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subjects': subjects,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'profileImageUrl': profileImageUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'maxConnections': maxConnections,
    };
  }

  // Create from Firestore document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      subjects: List<String>.from(map['subjects'] ?? []),
      location: LatLng(map['latitude'], map['longitude']),
      profileImageUrl: map['profileImageUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: DateTime.parse(map['lastSeen']),
    );
  }

  // Helper methods
  String getSubjectsString() => subjects.join(', ');

  // Copy with method for updates
  User copyWith({
    String? name,
    List<String>? subjects,
    LatLng? location,
    String? profileImageUrl,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email,
      subjects: subjects ?? this.subjects,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}