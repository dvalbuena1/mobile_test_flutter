import 'package:mobile_test_flutter/data/databases/local_storage.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageComment {
  final LocalStorage _localStorage = LocalStorage();

  Future<List<CommentModel>> selectByPostId(int postId) async {
    final db = await _localStorage.db;
    final List<Map<String, dynamic>> maps = await db.query('Comment', where: 'postId = ?', whereArgs: [postId]);
    return List.generate(maps.length, (i) {
      return CommentModel(
        id: maps[i]['id'],
        postId: maps[i]['postId'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        body: maps[i]['body'],
      );
    });
  }

  Future<void> insertAll(List<CommentModel> comments) async {
    final db = await _localStorage.db;
    final batch = db.batch();
    for (var i = 0; i < comments.length; i++) {
      batch.insert('Comment', comments[i].toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }
}