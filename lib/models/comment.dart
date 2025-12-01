import 'user.dart';

class Comment {
  final int id;
  final String content;
  final User user;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
