import 'package:equatable/equatable.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/models/user.dart';

abstract class PostDetailState extends Equatable {}

class InitialPostDetailState extends PostDetailState {
  @override
  List<Object?> get props => [];
}

class LoadingPostDetailState extends PostDetailState {
  @override
  List<Object?> get props => [];
}

class LoadedPostDetailState extends PostDetailState {
  final PostModel post;
  final UserModel user;

  LoadedPostDetailState({required this.post, required this.user});

  @override
  List<Object?> get props => [post, user];
}

class ErrorPostDetailState extends PostDetailState {
  final Object error;

  ErrorPostDetailState({required this.error});

  @override
  List<Object?> get props => [error];
}
