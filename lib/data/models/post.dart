class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;
  final bool favorite;

  final List<CommentModel>? comments;

  PostModel(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body,
      required this.favorite,
      this.comments});

  static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
        favorite: json['favorite'] ?? false,
        comments: null);
  }
}

class CommentModel {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentModel(
      {required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body});
}
