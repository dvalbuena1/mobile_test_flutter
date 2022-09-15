import 'package:dio/dio.dart';
import 'package:mobile_test_flutter/data/models/post.dart';

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
}
