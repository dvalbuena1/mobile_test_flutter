import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class CommentRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();

  Future<List<CommentModel>?> getComments(int postId) async {
    return await apiJsonPlaceholder.getComments(postId);
  }
}
