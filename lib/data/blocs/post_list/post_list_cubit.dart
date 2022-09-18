import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_state.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_state.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/repositories/post_repository.dart';

class PostListCubit extends Cubit<PostListState> {
  final ConnectivityCubit connectivityCubit;
  late StreamSubscription connectivityStreamSubscription;
  late bool isOnline;

  final PostRepository repository;

  PostListCubit({required this.connectivityCubit, required this.repository})
      : super(InitialPostListState()) {
    setConnectionState(connectivityCubit.state);
    connectivityStreamSubscription = connectivityCubit.stream.listen((state) {
      setConnectionState(state);
    });
  }

  void setConnectionState(ConnectivityState state) {
    if (state is ConnectedConnectivityState) {
      isOnline = true;
    } else if (state is DisconnectedConnectivityState) {
      isOnline = false;
    }
  }

  Future<void> getPosts(bool fromApi) async {
    try {
      emit(LoadingPostListState());
      List<PostModel>? posts;
      if (isOnline) {
        posts = fromApi
            ? await repository.getPostsFromApi()
            : await repository.getPostsOnline();
      } else {
        posts = await repository.getPostsOffline();
      }
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

  Future<void> addFavorite(int index) async {
    final state = this.state;
    if (state is LoadedPostListState) {
      final posts = state.posts;
      final favoritePosts = state.favoritePosts;
      final post = posts[index];
      post.favorite = true;
      posts.removeAt(index);
      await repository.updatePost(post);
      emit(LoadedPostListState(posts, List.of(favoritePosts)..add(post)));
    }
  }

  void removeFavorite(int index) async {
    final state = this.state;
    if (state is LoadedPostListState) {
      final posts = state.posts;
      final favoritePosts = state.favoritePosts;
      final post = favoritePosts[index];
      post.favorite = false;
      favoritePosts.removeAt(index);
      await repository.updatePost(post);
      emit(LoadedPostListState(List.of(posts)..insert(0, post), favoritePosts));
    }
  }

  Future<void> deletePost(int index, bool isFavorite) async {
    final state = this.state;
    if (state is LoadedPostListState) {
      final posts = state.posts;
      final favoritePosts = state.favoritePosts;
      if (isFavorite) {
        await repository.deletePost(favoritePosts[index]);
        emit(LoadedPostListState(
            posts, List.of(favoritePosts)..removeAt(index)));
      } else {
        await repository.deletePost(posts[index]);
        emit(LoadedPostListState(
            List.of(posts)..removeAt(index), favoritePosts));
      }
    }
  }

  Future<void> deleteAll() async {
    final state = this.state;
    if (state is LoadedPostListState) {
      await repository.deleteList(state.posts);
      emit(LoadedPostListState(const [], state.favoritePosts));
    }
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
