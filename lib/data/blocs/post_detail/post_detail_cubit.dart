import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_state.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_state.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/models/user.dart';
import 'package:mobile_test_flutter/data/repositories/comment_repository.dart';
import 'package:mobile_test_flutter/data/repositories/user_repository.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final ConnectivityCubit connectivityCubit;
  late StreamSubscription connectivityStreamSubscription;
  late bool isOnline;

  UserRepository userRepository = UserRepository();
  CommentRepository commentRepository = CommentRepository();

  PostDetailCubit({required this.connectivityCubit})
      : super(InitialPostDetailState()) {
    setConnectionState(connectivityCubit.state);
    connectivityCubit.stream.listen((state) {
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

  Future<void> getDetailInfo(PostModel post) async {
    try {
      emit(LoadingPostDetailState());
      UserModel? user;
      List<CommentModel>? comments;
      if (isOnline) {
        user = await userRepository.getUserOnline(post.userId);
        comments = await commentRepository.getCommentsOnline(post.id);
      } else {
        user = await userRepository.getUserOffline(post.userId);
        comments = await commentRepository.getCommentsOffline(post.id);
      }
      if (user != null && comments != null) {
        post.comments = comments;
        emit(LoadedPostDetailState(post, user));
      } else {
        emit(ErrorPostDetailState('Something went wrong'));
      }
    } catch (e, s) {
      print(s);
      emit(ErrorPostDetailState(e));
    }
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
