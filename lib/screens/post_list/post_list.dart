import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_state.dart';
import 'package:mobile_test_flutter/data/models/post.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  void initState() {
    BlocProvider.of<PostListCubit>(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListCubit, PostListState>(builder: (context, state) {
      if (state is LoadingPostListState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ErrorPostListState) {
        return Center(child: Text(state.error.toString()));
      } else if (state is LoadedPostListState) {
        final posts = state.posts;

        if (posts.isEmpty) {
          return const Center(child: Text('No posts to show'));
        }

        return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: (posts.length * 2),
            itemBuilder: (context, index) {
              if (index.isOdd) return const Divider();

              final indexTrue = index ~/ 2;
              return _PostItem(post: posts[indexTrue]);
            });
      } else {
        return Container();
      }
    });
  }
}

class _PostItem extends StatelessWidget {
  final PostModel post;

  const _PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      onTap: () {},
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                print(post.id);
              }),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              print(post.id);
            },
          ),
        ],
      ),
    );
  }
}
