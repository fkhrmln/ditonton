part of 'popular_series_bloc.dart';

@immutable
abstract class PopularSeriesState extends Equatable {
  const PopularSeriesState();

  @override
  List<Object> get props => [];
}

class PopularSeriesEmpty extends PopularSeriesState {}

class PopularSeriesLoading extends PopularSeriesState {}

class PopularSeriesError extends PopularSeriesState {
  final String message;

  const PopularSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularSeriesHasData extends PopularSeriesState {
  final List<Series> result;

  const PopularSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
