import 'package:news_app_mobile/models/comment.dart';
import 'user.dart';

class News {
  final int id;
  final String title;
  final String content;
  final String? image;
  final String category;
  final User user;
  final List<Comment> comments;
  final DateTime createdAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.category,
    required this.user,
    required this.comments,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      category: json['category'],
      user: User.fromJson(json['user']),
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
