import 'dart:convert';

import 'package:mobile_test_flutter/data/databases/local_storage.dart';
import 'package:mobile_test_flutter/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageUser {
  final LocalStorage _localStorage = LocalStorage();

  Future<UserModel?> selectById(int userId) async {
    final db = await _localStorage.db;
    final List<Map<String, dynamic>> maps =
        await db.query('User', where: 'id = ?', whereArgs: [userId]);
    if (maps.isNotEmpty) {
      Map<String, dynamic> map = {
        ...maps[0],
        "address": jsonDecode(maps[0]["address"]),
        "company": jsonDecode(maps[0]["company"]),
      };
      return UserModel.fromJson(map);
    } else {
      return null;
    }
  }

  Future<void> insert(UserModel user) async {
    final db = await _localStorage.db;
    Map<String, dynamic> map = user.toMap();
    map["address"] = jsonEncode(map["address"]);
    map["company"] = jsonEncode(map["company"]);
    await db.insert('User', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
