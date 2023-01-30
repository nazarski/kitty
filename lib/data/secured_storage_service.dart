import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorageService {
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<Map<String, dynamic>> readAllUsers() async {
    return await storage.readAll();
  }

  static Future<String?> readSingleUser(String key) async {
    return await storage.read(key: key);
  }

  static Future<void> saveUser(String id, String userInfo) async {
    await storage.write(key: id, value: userInfo);
    await saveLast(id);
  }

  static Future<void> deleteUsers() async {
    await storage.deleteAll();
  }

  static Future<void> deleteUser(String id) async {
    await storage.delete(key: id);
  }

  static Future<void> saveLast(String id) async {
    await storage.write(key: 'lastUser', value: id);
  }
}
