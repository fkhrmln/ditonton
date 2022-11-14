import 'package:core/styles/text_styles.dart';
import 'package:core/styles/colors.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/routes.dart';
import 'package:about/about.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_movies_bloc.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:search/search.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/pages/now_playing_movies_page.dart';
import 'package:core/presentation/pages/now_playing_series_page.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:core/presentation/pages/popular_series_page.dart';
import 'package:core/presentation/pages/series_detail_page.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/top_rated_series_page.dart';
import 'package:core/presentation/pages/watchlist_movies_page.dart';
import 'package:core/presentation/pages/watchlist_series_page.dart';
import 'package:core/presentation/provider/movie_detail_notifier.dart';
import 'package:core/presentation/provider/movie_list_notifier.dart';
import 'package:core/presentation/provider/now_playing_movies_notifier.dart';
import 'package:core/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/provider/top_rated_movies_notifier.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:core/presentation/provider/series_list_notifier.dart';
import 'package:core/presentation/provider/series_detail_notifier.dart';
import 'package:core/presentation/provider/now_playing_series_notifier.dart';
import 'package:core/presentation/provider/popular_series_notifier.dart';
import 'package:core/presentation/provider/watchlist_series_notifier.dart';
import 'package:core/presentation/provider/top_rated_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<NowPlayingMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<NowPlayingSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesSearchNotifier>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case NOW_PLAYING_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => NowPlayingMoviesPage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIES_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WATCHLIST_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case NOW_PLAYING_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => NowPlayingSeriesPage());
            case SERIES_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => SeriesDetailPage(id: id),
                settings: settings,
              );
            case WATCHLIST_SERIES_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchListSeriesPage());
            case POPULAR_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularSeriesPage());
            case TOP_RATED_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedSeriesPage());
            case SEARCH_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchSeriesPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
