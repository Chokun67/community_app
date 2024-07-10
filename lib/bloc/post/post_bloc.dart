import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_app/utility/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:community_app/models/post.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FlutterSecureStorage secureStorage;

  PostBloc({required this.secureStorage}) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<AddPost>(_onAddPost);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());

    try {
      final token = await secureStorage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/posts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Post> posts =
            jsonResponse.map((post) => Post.fromJson(post)).toList();
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostError(message: 'Failed to load posts'));
      }
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    
    try {
      final token = await secureStorage.read(key: 'token');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}/posts'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = event.title;
      request.fields['content'] = event.content;
      request.fields['categoryIds'] = jsonEncode(event.categoryIds);
      print(jsonEncode(event.categoryIds));
      if (event.image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', event.image!.path));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        add(FetchPosts());
      } else {
        emit(PostError(message: 'Failed to add post'));
      }
    } catch (error) {
      emit(PostError(message: error.toString()));
    }
  }
}
