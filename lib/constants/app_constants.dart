class AppConstants {
  static const String appName = 'SupplyMate';
  static const String currentVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String chatRoomsCollection = 'chat_rooms';
  static const String messagesCollection = 'messages';
  
  // App Limits
  static const int maxNearbyDistance = 5000; // meters
  static const int maxSubjects = 5;
  static const int maxMessageLength = 500;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
  
  // Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
}