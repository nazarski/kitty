import 'dart:async';
import 'dart:convert';

import 'package:kitty/models/user_model/user.dart';
import 'package:kitty/utils/secured_storage_utils.dart';
import 'package:uuid/uuid.dart';

class SecureStorageRepository {
  final uuid = const Uuid();

  Future<String> createUser({required User user}) async {
    final id = user.email.substring(0, user.email.indexOf('@'));
    final userInfo = jsonEncode(user);
    await SecuredStorageUtils.saveUser(id, userInfo);
    return id;
  }
}
