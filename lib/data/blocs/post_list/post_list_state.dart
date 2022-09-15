import 'package:equatable/equatable.dart';
import 'package:mobile_test_flutter/data/models/post.dart';

abstract class PostListState extends Equatable {}

class InitialPostListState extends PostListState {
  @override
  List<Object?> get props => [];
}

class LoadingPostListState extends PostListState {
  @override
  List<Object?> get props => [];
}

class LoadedPostListState extends PostListState {
  final List<PostModel> posts;
  final bool hasReachedMax;

  LoadedPostListState(this.posts, this.hasReachedMax);

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class ErrorPostListState extends PostListState {
  final Object error;

  ErrorPostListState(this.error);

  @override
  List<Object?> get props => [error];
}
