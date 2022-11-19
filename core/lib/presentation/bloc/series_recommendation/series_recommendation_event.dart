part of 'series_recommendation_bloc.dart';

@immutable
abstract class SeriesRecommendationEvent extends Equatable {
  const SeriesRecommendationEvent();

  @override
  List<Object> get props => [];
}

class OnFetchSeriesRecommedation extends SeriesRecommendationEvent {
  final int id;

  const OnFetchSeriesRecommedation(this.id);

  @override
  List<Object> get props => [id];
}
