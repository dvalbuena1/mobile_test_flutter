import 'package:mobile_test_flutter/data/dao/local_storage/local_storage_comment.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class CommentRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();
  final LocalStorageComment localStorageComment = LocalStorageComment();

  Future<List<CommentModel>?> getCommentsOnline(int postId) async {
    List<CommentModel> dbList =
        await localStorageComment.selectByPostId(postId);
    if (dbList.isNotEmpty) {
      return dbList;
    } else {
      List<CommentModel>? apiList =
          await apiJsonPlaceholder.getComments(postId);
      if (apiList != null) {
        localStorageComment.insertAll(apiList);
      }
      return apiList;
    }
  }

  Future<List<CommentModel>> getCommentsOffline(int postId) async {
    List<CommentModel> dbList =
        await localStorageComment.selectByPostId(postId);
    return dbList;
  }
}
