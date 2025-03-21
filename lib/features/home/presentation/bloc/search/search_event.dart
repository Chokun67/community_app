part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsByCategory extends SearchEvent {
  final int categoryId;

  const FetchPostsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
