import 'package:mobile_test_flutter/data/dao/local_storage/local_storage_post.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/network/api_json_placeholder.dart';

class PostRepository {
  final ApiJsonPlaceholder apiJsonPlaceholder = ApiJsonPlaceholder();
  final LocalStoragePost localStoragePost = LocalStoragePost();

  Future<List<PostModel>?> getPostsFromApi() async {
    List<PostModel>? posts = await apiJsonPlaceholder.getPosts();
    if (posts != null) {
      localStoragePost.insertAll(posts);
    }
    return posts;
  }

  Future<List<PostModel>?> getPostsOnline() async {
    List<PostModel> dbList = await localStoragePost.selectAll();
    if (dbList.isNotEmpty) {
      return dbList;
    } else {
      return await getPostsFromApi();
    }
  }

  Future<List<PostModel>?> getPostsOffline() async {
    List<PostModel> dbList = await localStoragePost.selectAll();
    return dbList;
  }

  Future<void> updatePost(PostModel post) async {
    await localStoragePost.update(post);
  }

  Future<void> deletePost(PostModel post) async {
    await localStoragePost.delete(post);
  }

  Future<void> deleteList(List<PostModel> posts) async {
    await localStoragePost.deleteList(posts);
  }
}
