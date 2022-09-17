import 'package:dio/dio.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/models/user.dart';

class ApiJsonPlaceholder {
  final String baseUrl = "https://jsonplaceholder.typicode.com/";

  Future<List<PostModel>?> getPosts() async {
    try {
      final response = await Dio().get(baseUrl + "posts");
      if (response.data != null) {
        return (response.data as List)
            .map((e) => PostModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e.message);
    }
  }

  Future<UserModel?> getUser(int userId) async {
    try {
      final response = await Dio().get(baseUrl + "users/" + userId.toString());
      if (response.data != null) {
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e.message);
    }
  }

  Future<List<CommentModel>?> getComments(int postId) async {
    try {
      final response =
          await Dio().get(baseUrl + "posts/" + postId.toString() + "/comments");
      if (response.data != null) {
        return (response.data as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      throw Exception(e.message);
    }
  }
}
