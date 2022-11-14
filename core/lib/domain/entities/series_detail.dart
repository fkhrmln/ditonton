import '../../domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class SeriesDetail extends Equatable {
  SeriesDetail({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String backdropPath;
  final List<int> episodeRunTime;
  final List<Genre> genres;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        episodeRunTime,
        genres,
        id,
        name,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
