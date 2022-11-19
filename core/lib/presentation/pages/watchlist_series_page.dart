import 'package:core/presentation/cubit/series_watchlist/series_watchlist_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
import '../../presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';

class WatchListSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-series';

  @override
  _WatchListSeriesPageState createState() => _WatchListSeriesPageState();
}

class _WatchListSeriesPageState extends State<WatchListSeriesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SeriesWatchlistCubit>().fetchWatchlistSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<SeriesWatchlistCubit>().fetchWatchlistSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SeriesWatchlistCubit, SeriesWatchlistState>(
          builder: (context, state) {
            if (state is SeriesWatchlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SeriesWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return SeriesCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is SeriesWatchlistError) {
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
