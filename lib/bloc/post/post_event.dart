import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}

class AddPost extends PostEvent {
  final String title;
  final String content;
  final List<int> categoryIds;
  final dynamic image;

  AddPost({
    required this.title,
    required this.content,
    required this.categoryIds,
    this.image,
  });

  @override
  List<Object> get props => [title, content, categoryIds, image];
}
