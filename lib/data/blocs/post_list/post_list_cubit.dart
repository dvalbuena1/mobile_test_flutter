import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_state.dart';

class PostListCubit extends Cubit<PostListState>{
  PostListCubit() : super(InitialPostListState());
}