import 'package:core/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-movie';

  @override
  _NowPlayingMoviesPageState createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingMoviesBloc>().add(OnFetchNowPlayingMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
          builder: (context, state) {
            if (state is NowPlayingMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingMoviesHasData) {
              final result = state.result;
              return ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final movie = result[index];

                  return MovieCard(movie);
                },
              );
            } else if (state is NowPlayingMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
