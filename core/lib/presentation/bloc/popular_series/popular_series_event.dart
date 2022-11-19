part of 'popular_series_bloc.dart';

@immutable
abstract class PopularSeriesEvent extends Equatable {
  const PopularSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnFetchPopularSeries extends PopularSeriesEvent {
  const OnFetchPopularSeries();

  @override
  List<Object> get props => [];
}
