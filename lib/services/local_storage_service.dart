import 'package:hive/hive.dart';

class LocalStorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('message_cache');
  }

  static Future<void> cacheMessage(String chatRoomId, Map<String, dynamic> message) async {
    final box = Hive.box('message_cache');
    final messages = box.get(chatRoomId, defaultValue: []) as List;
    messages.add(message);
    await box.put(chatRoomId, messages);
  }

  static List<Map<String, dynamic>> getCachedMessages(String chatRoomId) {
    final box = Hive.box('message_cache');
    return (box.get(chatRoomId, defaultValue: []) as List).cast<Map<String, dynamic>>();
  }

  static Future<void> clearCache(String chatRoomId) async {
    final box = Hive.box('message_cache');
    await box.delete(chatRoomId);
  }
}