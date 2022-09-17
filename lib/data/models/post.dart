class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;
  bool favorite;

  List<CommentModel>? comments;

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'favorite': favorite ? 1 : 0,
    };
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

  static CommentModel fromJson(Map<String, dynamic> json) {
    return CommentModel(
        postId: json['postId'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
        body: json['body']);
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}
