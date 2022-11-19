part of 'series_watchlist_cubit.dart';

@immutable
abstract class SeriesWatchlistState extends Equatable {
  const SeriesWatchlistState();

  @override
  List<Object> get props => [];
}

class SeriesWatchlistEmpty extends SeriesWatchlistState {}

class SeriesWatchlistLoading extends SeriesWatchlistState {}

class SeriesWatchlistError extends SeriesWatchlistState {
  final String message;

  const SeriesWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesWatchlistHasData extends SeriesWatchlistState {
  final List<Series> result;

  const SeriesWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class SeriesWatchlistIsAdedd extends SeriesWatchlistState {
  bool isAdded = false;

  SeriesWatchlistIsAdedd(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}
