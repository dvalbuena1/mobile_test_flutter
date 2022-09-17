import 'package:mobile_test_flutter/data/databases/local_storage.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:sqflite/sqflite.dart';

class LocalStoragePost {
  final LocalStorage _localStorage = LocalStorage();

  Future<List<PostModel>> selectAll() async {
    final db = await _localStorage.db;
    final List<Map<String, dynamic>> maps = await db.query('Post');
    return List.generate(maps.length, (i) {
      return PostModel(
        id: maps[i]['id'],
        userId: maps[i]['userId'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        favorite: maps[i]['favorite'] == 1,
      );
    });
  }

  Future<void> insertAll(List<PostModel> posts) async {
    final db = await _localStorage.db;
    final batch = db.batch();
    for (var i = 0; i < posts.length; i++) {
      batch.insert('Post', posts[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> update(PostModel post) async {
    final db = await _localStorage.db;
    await db
        .update('Post', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
  }

  Future<void> delete(PostModel post) async {
    final db = await _localStorage.db;
    await db.delete('Post', where: 'id = ?', whereArgs: [post.id]);
  }

  Future<void> deleteList(List<PostModel> posts) async {
    final db = await _localStorage.db;
    final batch = db.batch();
    for (var i = 0; i < posts.length; i++) {
      batch.delete('Post', where: 'id = ?', whereArgs: [posts[i].id]);
    }
    await batch.commit();
  }
}
