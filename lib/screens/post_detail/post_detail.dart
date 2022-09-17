import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_state.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/models/user.dart';

class PostDetail extends StatefulWidget {
  PostModel post;

  PostDetail({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostDetailCubit>(context).getDetailInfo(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Detail Post ${widget.post.id}"),
        ),
        body: BlocBuilder<PostDetailCubit, PostDetailState>(
          builder: (context, state) {
            if (state is LoadingPostDetailState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorPostDetailState) {
              return Center(child: Text(state.error.toString()));
            } else if (state is LoadedPostDetailState) {
              final user = state.user;
              widget.post = state.post;

              return SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(widget.post.title,
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10.0),
                        Text(widget.post.body,
                            style: const TextStyle(fontSize: 16.0)),
                        const SizedBox(height: 20.0),
                        _UserInfo(user: user),
                        const SizedBox(height: 50.0),
                        _Comments(comments: widget.post.comments ?? []),
                      ],
                    )),
              );
            } else {
              return const Center(child: Text("No data"));
            }
          },
        ));
  }
}

class _UserInfo extends StatelessWidget {
  final UserModel user;

  const _UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("By ${user.name}",
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        Text("@${user.username}", style: const TextStyle(fontSize: 14.0))
      ],
    );
  }
}

class _Comments extends StatelessWidget {
  final List<CommentModel> comments;

  const _Comments({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text("Comments (${comments.length})",
              textAlign: TextAlign.left,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(comment.name,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: Text(comment.body,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 14.0)),
                      )
                    ],
                  ));
            })
      ],
    );
  }
}
