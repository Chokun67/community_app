import 'package:community_app/features/home/data/models/category.dart';
import 'package:community_app/features/home/data/models/user.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String? image;
  final String createdAt;
  final User user;
  final List<Category> categories;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.createdAt,
    required this.user,
    required this.categories,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      createdAt: json['createdAt'],
      user: User.fromJson(json['user']),
      categories: (json['categories'] as List).map((category) => Category.fromJson(category)).toList(),
    );
  }
}
