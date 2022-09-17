import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_state.dart';
import 'package:mobile_test_flutter/data/repositories/post_repository.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(InitialPostListState());

  PostRepository repository = PostRepository();

  Future<void> getPosts() async {
    try {
      emit(LoadingPostListState());
      final posts = await repository.getPosts();
      if (posts != null) {
        emit(LoadedPostListState(posts.where((p) => !p.favorite).toList(),
            posts.where((p) => p.favorite).toList()));
      } else {
        emit(ErrorPostListState('Something went wrong'));
      }
    } catch (e) {
      emit(ErrorPostListState(e));
    }
  }

  void addFavorite(int index) {
    final state = this.state;
    if (state is LoadedPostListState) {
      final posts = state.posts;
      final favoritePosts = state.favoritePosts;
      final post = posts[index];
      post.favorite = true;
      posts.removeAt(index);
      emit(LoadedPostListState(posts, List.of(favoritePosts)..add(post)));
    }
  }

  void removeFavorite(int index) {
    final state = this.state;
    if (state is LoadedPostListState) {
      final posts = state.posts;
      final favoritePosts = state.favoritePosts;
      final post = favoritePosts[index];
      post.favorite = false;
      favoritePosts.removeAt(index);
      emit(LoadedPostListState(List.of(posts)..insert(0, post), favoritePosts));
    }
  }
}
