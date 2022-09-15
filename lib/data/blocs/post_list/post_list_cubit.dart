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
        emit(LoadedPostListState(posts, false));
      } else {
        emit(LoadedPostListState(const [], false));
      }
    } catch (e) {
      emit(ErrorPostListState(e));
    }
  }
}