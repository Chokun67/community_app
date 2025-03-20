import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_app/features/home/data/models/post.dart';
import 'package:community_app/utility/constants.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FlutterSecureStorage secureStorage;

  SearchBloc({required this.secureStorage}) : super(SearchInitial()) {
    on<FetchPostsByCategory>((event, emit) async {
      emit(SearchLoading());
      try {
        final token = await secureStorage.read(key: 'token');
        final response = await http.get(
          Uri.parse('${Constants.baseUrl}/posts/category/${event.categoryId}'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final postData = json.decode(response.body) as List;
          final posts = postData.map((post) => Post.fromJson(post)).toList();
          emit(SearchLoaded(posts));
        } else {
          emit(const SearchError('Failed to load posts'));
        }
      } catch (e) {
        emit(const SearchError('Failed to load posts'));
      }
    });
  }
}
