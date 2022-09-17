import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/config/routes.dart';
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
    super.initState();
    BlocProvider.of<PostListCubit>(context).getPosts(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<PostListCubit>(context).getPosts(true);
            },
          )
        ],
      ),
      body:
          BlocBuilder<PostListCubit, PostListState>(builder: (context, state) {
        if (state is LoadingPostListState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorPostListState) {
          return Center(child: Text(state.error.toString()));
        } else if (state is LoadedPostListState) {
          final posts = state.posts;
          final favoritePosts = state.favoritePosts;

          if (posts.isEmpty && favoritePosts.isEmpty) {
            return const Center(child: Text('No posts to show'));
          }

          List<dynamic> list = [];
          list.add(const ListTile(
            title: Text("Favorite Posts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ));
          for (var i = 0; i < favoritePosts.length; i++) {
            list.add({i: favoritePosts[i]});
            list.add(const Divider());
          }
          list.add(const SizedBox(height: 20));
          list.add(ListTile(
            title: const Text("Posts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {
                  BlocProvider.of<PostListCubit>(context).deleteAll();
                }),
          ));
          for (var i = 0; i < posts.length; i++) {
            list.add({i: posts[i]});
            list.add(const Divider());
          }

          return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount:
                  1 + (favoritePosts.length * 2) + 1 + (posts.length * 2) + 1,
              itemBuilder: (context, index) {
                final value = list[index];
                if (value is Widget) {
                  return value;
                } else if (value is Map) {
                  final i = value.keys.first;
                  final post = value.values.first;
                  return _PostItem(key: UniqueKey(), post: post, index: i);
                }
                return const SizedBox();
              });
        } else {
          return Container();
        }
      }),
    );
  }
}

class _PostItem extends StatefulWidget {
  final PostModel post;
  final int index;

  const _PostItem({Key? key, required this.post, required this.index})
      : super(key: key);

  @override
  State createState() => _PostItemState();
}

class _PostItemState extends State<_PostItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget.post.id.toString()),
      title: Text(widget.post.title),
      onTap: () {
        Navigator.pushNamed(context, Routes.post, arguments: widget.post);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.post.favorite
              ? IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () {
                    BlocProvider.of<PostListCubit>(context)
                        .removeFavorite(widget.index);
                  })
              : IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {
                    BlocProvider.of<PostListCubit>(context)
                        .addFavorite(widget.index);
                  }),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              BlocProvider.of<PostListCubit>(context)
                  .deletePost(widget.index, widget.post.favorite);
            },
          ),
        ],
      ),
    );
  }
}
