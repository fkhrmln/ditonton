part of 'series_recommendation_bloc.dart';

@immutable
abstract class SeriesRecommendationState extends Equatable {
  const SeriesRecommendationState();

  @override
  List<Object> get props => [];
}

class SeriesRecommendationEmpty extends SeriesRecommendationState {}

class SeriesRecommendationLoading extends SeriesRecommendationState {}

class SeriesRecommendationError extends SeriesRecommendationState {
  final String message;

  const SeriesRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesRecommendationHasData extends SeriesRecommendationState {
  final List<Series> result;

  const SeriesRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}
