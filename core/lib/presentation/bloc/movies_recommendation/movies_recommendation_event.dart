part of 'movies_recommendation_bloc.dart';

@immutable
abstract class MoviesRecommendationEvent extends Equatable {
  const MoviesRecommendationEvent();

  @override
  List<Object> get props => [];
}

class OnFetchMoviesRecommendation extends MoviesRecommendationEvent {
  final int id;

  const OnFetchMoviesRecommendation(this.id);

  @override
  List<Object> get props => [id];
}
