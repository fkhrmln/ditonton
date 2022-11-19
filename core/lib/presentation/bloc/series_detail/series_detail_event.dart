part of 'series_detail_bloc.dart';

@immutable
abstract class SeriesDetailEvent extends Equatable {
  const SeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFetchSeriesDetail extends SeriesDetailEvent {
  final int id;

  const OnFetchSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}
