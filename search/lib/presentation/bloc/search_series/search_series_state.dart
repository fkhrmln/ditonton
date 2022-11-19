part of 'search_series_bloc.dart';

@immutable
abstract class SearchSeriesState extends Equatable {
  const SearchSeriesState();

  @override
  List<Object> get props => [];
}

class SearchSeriesEmpty extends SearchSeriesState {}

class SearchSeriesLoading extends SearchSeriesState {}

class SearchSeriesError extends SearchSeriesState {
  final String message;

  const SearchSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchSeriesHasData extends SearchSeriesState {
  final List<Series> result;

  const SearchSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
