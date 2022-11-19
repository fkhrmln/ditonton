part of 'popular_movies_bloc.dart';

@immutable
abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnFetchPopularMovies extends PopularMoviesEvent {
  const OnFetchPopularMovies();

  @override
  List<Object> get props => [];
}
