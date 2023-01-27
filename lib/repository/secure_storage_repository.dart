import 'dart:async';
import 'dart:convert';

import 'package:kitty/models/user_model/user.dart';
import 'package:kitty/utils/secured_storage_utils.dart';
import 'package:uuid/uuid.dart';

class SecureStorageRepository {
  final uuid = const Uuid();

  Future<String> createUser({required User user}) async {
    final id = user.email;
    final userInfo = jsonEncode(user);
    await SecuredStorageUtils.saveUser(id, userInfo);
    return id;
  }

  Future<bool> checkAvailability(String email) async {
    final users = await SecuredStorageUtils.readAllUsers();
    return users.containsKey(email);
  }
  Future<User?> getUser(String email)async{
    final user = await SecuredStorageUtils.readSingleUser(email);
    if(user == null) return null;
    return User.fromJson(jsonDecode(user));
  }
  Future<User?> getLastUser()async{
    final last = await SecuredStorageUtils.readSingleUser('lastUser');
    if(last == null) return null;
    return await getUser(last);
  }
  Future<void> removeLastUser()async{
    await SecuredStorageUtils.deleteUser('lastUser');
  }
  Future<void> addLastUser(String id)async{
    await SecuredStorageUtils.saveLast(id);
  }
}
