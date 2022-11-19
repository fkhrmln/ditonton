part of 'movies_detail_bloc.dart';

@immutable
abstract class MoviesDetailEvent extends Equatable {
  const MoviesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFetchMoviesDetail extends MoviesDetailEvent {
  final int id;

  const OnFetchMoviesDetail(this.id);

  @override
  List<Object> get props => [id];
}
