import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorageUtils{
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  static Future<Map<String, dynamic>> readAllUsers()async{
    return await storage.readAll();
  }
  static Future<String?> readSingleUser(String key)async{
    return await storage.read(key: key);
  }
  static Future<void> saveUser(String id, String userInfo)async{
    await storage.write(key: id, value: userInfo);
    await storage.write(key: 'lastUser', value: id);

  }
}