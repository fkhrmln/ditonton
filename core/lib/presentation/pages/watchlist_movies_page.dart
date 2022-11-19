import 'package:core/presentation/cubit/movies_watchlist/movies_watchlist_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
import '../../presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MoviesWatchlistCubit>().fetchWatchlistMoveis());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<MoviesWatchlistCubit>().fetchWatchlistMoveis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviesWatchlistCubit, MoviesWatchlistState>(
          builder: (context, state) {
            if (state is MoviesWatchlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MoviesWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is MoviesWatchlistError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
