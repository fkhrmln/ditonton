part of 'movies_watchlist_cubit.dart';

@immutable
abstract class MoviesWatchlistState extends Equatable {
  const MoviesWatchlistState();

  @override
  List<Object> get props => [];
}

class MoviesWatchlistEmpty extends MoviesWatchlistState {}

class MoviesWatchlistLoading extends MoviesWatchlistState {}

class MoviesWatchlistError extends MoviesWatchlistState {
  final String message;

  const MoviesWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MoviesWatchlistHasData extends MoviesWatchlistState {
  final List<Movie> result;

  const MoviesWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesWatchlistIsAdedd extends MoviesWatchlistState {
  bool isAdded = false;

  MoviesWatchlistIsAdedd(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}
