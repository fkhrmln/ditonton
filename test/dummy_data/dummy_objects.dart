import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/series_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/entities/series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testSeriesTable = SeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testSeriesDetail = SeriesDetail(
  adult: false,
  backdropPath: "backdropPath",
  episodeRunTime: [60],
  genres: [
    Genre(
      id: 1,
      name: "Drama",
    )
  ],
  id: 1,
  name: "name",
  overview: "overview",
  popularity: 1.0,
  posterPath: "posterPath",
  voteAverage: 1.0,
  voteCount: 1,
);

final testWatchlistSeries = Series.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeries = Series(
  backdropPath: "/5vUux2vNUTqwCzb7tVcH18XnsF.jpg",
  genreIds: [18, 80],
  id: 113988,
  name: "Dahmer – Monster: The Jeffrey Dahmer Story",
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Dahmer – Monster: The Jeffrey Dahmer Story",
  overview:
      "Across more than a decade, 17 teen boys and young men were murdered by convicted killer Jeffrey Dahmer. How did he evade arrest for so long?",
  popularity: 3037.8,
  posterPath: "/qAv0UoAQVZWd6HGc83fsli1aKmo.jpg",
  voteAverage: 8.3,
  voteCount: 1192,
);

final testSeriesList = [testSeries];
