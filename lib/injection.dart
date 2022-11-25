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

import 'package:core/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:core/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:core/presentation/bloc/now_playing_series/now_playing_series_bloc.dart';
import 'package:core/presentation/bloc/popular_series/popular_series_bloc.dart';
import 'package:core/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:core/presentation/bloc/movies_detail/movies_detail_bloc.dart';
import 'package:core/presentation/bloc/series_detail/series_detail_bloc.dart';
import 'package:core/presentation/bloc/movies_recommendation/movies_recommendation_bloc.dart';
import 'package:core/presentation/bloc/series_recommendation/series_recommendation_bloc.dart';
import 'package:core/presentation/cubit/movies_watchlist/movies_watchlist_cubit.dart';
import 'package:core/presentation/cubit/series_watchlist/series_watchlist_cubit.dart';
import 'package:ditonton/data/ssl/ssl_helper.dart';
import 'package:search/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:search/presentation/bloc/search_series/search_series_bloc.dart';
import 'package:search/search.dart';

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
  locator.registerFactory(
    () => NowPlayingMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MoviesDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MoviesRecommendationBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesRecommendationBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MoviesWatchlistCubit(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesWatchlistCubit(
      locator(),
      locator(),
      locator(),
      locator(),
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
  locator.registerLazySingleton(() => SSLHelper.client);
}
