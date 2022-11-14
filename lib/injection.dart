import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/db/database_series_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/series_local_data_source.dart';
import 'package:core/data/datasources/series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/series_repository_impl.dart';
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
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/presentation/provider/movie_detail_notifier.dart';
import 'package:core/presentation/provider/movie_list_notifier.dart';
import 'package:core/presentation/provider/now_playing_movies_notifier.dart';
import 'package:core/presentation/provider/now_playing_series_notifier.dart';
import 'package:core/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/provider/popular_series_notifier.dart';
import 'package:core/presentation/provider/series_detail_notifier.dart';
import 'package:core/presentation/provider/series_list_notifier.dart';
import 'package:search/presentation/bloc/search_movies_bloc.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:search/search.dart';
import 'package:core/presentation/provider/top_rated_movies_notifier.dart';
import 'package:core/presentation/provider/top_rated_series_notifier.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:core/presentation/provider/watchlist_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => SearchMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => SearchSeriesBloc(
      locator(),
    ),
  );

  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesListNotifier(
      getNowPlayingSeries: locator(),
      getPopularSeries: locator(),
      getTopRatedSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesDetailNotifier(
      getSeriesDetail: locator(),
      getSeriesRecommendations: locator(),
      getWatchListSeriesStatus: locator(),
      saveWatchListSeries: locator(),
      removeWatchListSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedSeriesNotifier(
      getTopRatedSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistSeriesNotifier(
      getWatchlistSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesSearchNotifier(
      searchSeries: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListSeriesStatus(locator()));
  locator.registerLazySingleton(() => RemoveWatchListSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchListSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<SeriesRemoteDataSource>(
      () => SeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<SeriesLocalDataSource>(
      () => SeriesLocalDataSourceImpl(databaseSeriesHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<DatabaseSeriesHelper>(() => DatabaseSeriesHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
