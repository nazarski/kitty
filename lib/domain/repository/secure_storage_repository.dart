import 'dart:async';
import 'dart:convert';

import 'package:kitty/data/secured_storage_service.dart';
import 'package:kitty/domain/models/user_model/user.dart';
import 'package:uuid/uuid.dart';

class SecureStorageRepository {
  final uuid = const Uuid();

  Future<String> createUser({required User user}) async {
    final id = user.email;
    final userInfo = jsonEncode(user);
    await SecuredStorageService.saveUser(id, userInfo);
    return id;
  }

  Future<bool> checkAvailability(String email) async {
    final users = await SecuredStorageService.readAllUsers();
    return users.containsKey(email);
  }
  Future<User?> getUser(String email)async{
    final user = await SecuredStorageService.readSingleUser(email);
    if(user == null) return null;
    return User.fromJson(jsonDecode(user));
  }
  Future<User?> getLastUser()async{
    final last = await SecuredStorageService.readSingleUser('lastUser');
    if(last == null) return null;
    return await getUser(last);
  }
  Future<void> removeLastUser()async{
    await SecuredStorageService.deleteUser('lastUser');
  }
  Future<void> addLastUser(String id)async{
    await SecuredStorageService.saveLast(id);
  }
}
