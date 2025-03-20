import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_app/utility/constants.dart';
import 'package:community_app/features/home/data/models/post.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FlutterSecureStorage secureStorage;

  ProfileBloc({required this.secureStorage}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final token = await secureStorage.read(key: 'token');
        final userResponse = await http.get(
          Uri.parse('${Constants.baseUrl}/users/1'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        final postResponse = await http.get(
          Uri.parse('${Constants.baseUrl}/posts/user/token'),
          headers: {'Authorization': 'Bearer $token'},
        );



        if (userResponse.statusCode == 200 && postResponse.statusCode == 200) {
          final userData = json.decode(userResponse.body);
          List jsonResponse = json.decode(postResponse.body);
                  debugPrint(jsonResponse.toString());
          List<Post> posts = jsonResponse.map((post) => Post.fromJson(post)).toList();
          emit(ProfileLoaded(userData, posts));
        } else {
          emit(const ProfileError('Failed to load profile or posts data'));
        }
      } catch (e) {
        emit(const ProfileError('Failed to load profile or posts data2'));
      }
    });
  }
}
