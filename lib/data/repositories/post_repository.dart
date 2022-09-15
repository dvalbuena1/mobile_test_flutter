import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class PostRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();

  Future<List<PostModel>?> getPosts() async {
    return await apiJsonPlaceholder.getPosts();
  }
}
