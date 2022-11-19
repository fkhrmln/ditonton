import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:core/presentation/bloc/now_playing_series/now_playing_series_bloc.dart';
import 'package:core/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/bloc/popular_series/popular_series_bloc.dart';
import 'package:core/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:core/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../styles/text_styles.dart';
import 'package:about/about.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/series.dart';
import '../../presentation/pages/movie_detail_page.dart';
import '../../presentation/pages/now_playing_movies_page.dart';
import '../../presentation/pages/now_playing_series_page.dart';
import '../../presentation/pages/popular_movies_page.dart';
import '../../presentation/pages/popular_series_page.dart';
import '../../presentation/pages/series_detail_page.dart';
import '../../presentation/pages/top_rated_movies_page.dart';
import '../../presentation/pages/top_rated_series_page.dart';
import '../../presentation/pages/watchlist_movies_page.dart';
import '../../presentation/pages/watchlist_series_page.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMoviesBloc>().add(OnFetchNowPlayingMovies());
      context.read<PopularMoviesBloc>().add(OnFetchPopularMovies());
      context.read<TopRatedMoviesBloc>().add(OnFetchTopRatedMovies());
    });
    Future.microtask(() {
      context.read<NowPlayingSeriesBloc>().add(OnFetchNowPlayingSeries());
      context.read<PopularSeriesBloc>().add(OnFetchPopularSeries());
      context.read<TopRatedSeriesBloc>().add(OnFetchTopRatedSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Fakhri Maulana'),
              accountEmail: Text('p190x0367@dicoding.org'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search Movies'),
              onTap: () {
                Navigator.pushNamed(context, SEARCH_MOVIES_ROUTE);
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search Series'),
              onTap: () {
                Navigator.pushNamed(context, SEARCH_SERIES_ROUTE);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchListSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('DITONTON'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing Movies',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                builder: (context, state) {
                  if (state is NowPlayingMoviesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingMoviesHasData) {
                    return MovieList(state.result);
                  } else if (state is NowPlayingMoviesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular Movies',
                onTap: () => Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  if (state is PopularMoviesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularMoviesHasData) {
                    return MovieList(state.result);
                  } else if (state is PopularMoviesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated Movies',
                onTap: () => Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedMoviesHasData) {
                    return MovieList(state.result);
                  } else if (state is TopRatedMoviesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Now Playing Series',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<NowPlayingSeriesBloc, NowPlayingSeriesState>(
                builder: (context, state) {
                  if (state is NowPlayingSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingSeriesHasData) {
                    return SeriesList(state.result);
                  } else if (state is NowPlayingSeriesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular Series',
                onTap: () => Navigator.pushNamed(context, PopularSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
                builder: (context, state) {
                  if (state is PopularSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularSeriesHasData) {
                    return SeriesList(state.result);
                  } else if (state is PopularSeriesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated Series',
                onTap: () => Navigator.pushNamed(context, TopRatedSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedSeriesBloc, TopRatedSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedSeriesHasData) {
                    return SeriesList(state.result);
                  } else if (state is TopRatedSeriesError) {
                    return const Text('Failed');
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({
    required String title,
    required Function() onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class SeriesList extends StatelessWidget {
  final List<Series> series;

  SeriesList(this.series);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final serie = series[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: serie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${serie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: series.length,
      ),
    );
  }
}
