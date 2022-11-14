import '../models/genre_model.dart';
import '../../domain/entities/series_detail.dart';
import 'package:equatable/equatable.dart';

class SeriesDetailResponse extends Equatable {
  SeriesDetailResponse({
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
  final List<GenreModel> genres;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;
  final int voteCount;

  factory SeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeriesDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        genres: List<GenreModel>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "id": id,
        "name": name,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  SeriesDetail toEntity() {
    return SeriesDetail(
      adult: this.adult,
      backdropPath: this.backdropPath,
      episodeRunTime: this.episodeRunTime,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      name: this.name,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
    );
  }

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
