part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Post> posts;

  const SearchLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
