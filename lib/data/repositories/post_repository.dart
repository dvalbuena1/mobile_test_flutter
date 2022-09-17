import 'package:mobile_test_flutter/data/dao/local_storage/local_storage_post.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class PostRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();
  final LocalStoragePost localStoragePost = LocalStoragePost();

  Future<List<PostModel>?> getPostsOnline() async {
    List<PostModel> dbList = await localStoragePost.selectAll();
    if (dbList.isNotEmpty) {
      return dbList;
    } else {
      List<PostModel>? apiList = await apiJsonPlaceholder.getPosts();
      if (apiList != null) {
        localStoragePost.insertAll(apiList);
      }
      return apiList;
    }
  }

  Future<List<PostModel>?> getPostsOffline() async {
    List<PostModel> dbList = await localStoragePost.selectAll();
    return dbList;
  }
}
