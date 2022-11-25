import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/db/database_series_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/series_local_data_source.dart';
import 'package:core/data/datasources/series_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  SeriesRepository,
  SeriesRemoteDataSource,
  SeriesLocalDataSource,
  DatabaseSeriesHelper,
], customMocks: [
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}

  // GetNowPlayingMovies,
  // GetNowPlayingSeries,
  // GetPopularMovies,
  // GetPopularSeries,
  // GetTopRatedMovies,
  // GetTopRatedSeries,
  // GetMovieDetail,
  // GetSeriesDetail,
  // GetMovieRecommendations,
  // GetSeriesRecommendations,
  // GetWatchlistMovies,
  // GetWatchlistSeries,
  // GetWatchListStatus,
  // GetWatchListSeriesStatus