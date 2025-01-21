import 'package:community_app/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/categories'));

      if (response.statusCode == 200) {
        final categories = json.decode(response.body);
        emit(CategoriesLoaded(categories));
      } else {
        emit(const CategoriesError('Failed to load categories'));
      }
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}

