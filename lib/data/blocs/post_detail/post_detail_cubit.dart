import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_state.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/repositories/comment_repository.dart';
import 'package:mobile_test_flutter/data/repositories/user_repository.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  PostDetailCubit() : super(InitialPostDetailState());

  UserRepository userRepository = UserRepository();
  CommentRepository commentRepository = CommentRepository();

  Future<void> getDetailInfo(PostModel post) async {
    try {
      emit(LoadingPostDetailState());
      final user = await userRepository.getUser(post.userId);
      final comments = await commentRepository.getComments(post.id);
      if (user != null && comments != null) {
        post.comments = comments;
        emit(LoadedPostDetailState(post, user));
      } else {
        emit(ErrorPostDetailState('Something went wrong'));
      }
    } catch (e) {
      emit(ErrorPostDetailState(e));
    }
  }
}
