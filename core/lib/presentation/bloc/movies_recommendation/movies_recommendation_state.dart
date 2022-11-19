part of 'movies_recommendation_bloc.dart';

@immutable
abstract class MoviesRecommendationState extends Equatable {
  const MoviesRecommendationState();

  @override
  List<Object> get props => [];
}

class MoviesRecommendationEmpty extends MoviesRecommendationState {}

class MoviesRecommendationLoading extends MoviesRecommendationState {}

class MoviesRecommendationError extends MoviesRecommendationState {
  final String message;

  const MoviesRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class MoviesRecommendationHasData extends MoviesRecommendationState {
  final List<Movie> result;

  const MoviesRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}
