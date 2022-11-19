import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/db/database_series_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/series_local_data_source.dart';
import 'package:core/data/datasources/series_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_now_playing_series.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_series.dart';
import 'package:core/domain/usecases/get_series_detail.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_series.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  SeriesRepository,
  SeriesRemoteDataSource,
  SeriesLocalDataSource,
  DatabaseSeriesHelper
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
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