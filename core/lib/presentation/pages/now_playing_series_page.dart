import 'package:core/presentation/bloc/now_playing_series/now_playing_series_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';

class NowPlayingSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-series';

  @override
  _NowPlayingSeriesPageState createState() => _NowPlayingSeriesPageState();
}

class _NowPlayingSeriesPageState extends State<NowPlayingSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingSeriesBloc>().add(OnFetchNowPlayingSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingSeriesBloc, NowPlayingSeriesState>(
          builder: (context, state) {
            if (state is NowPlayingSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingSeriesHasData) {
              final result = state.result;
              return ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final movie = result[index];

                  return SeriesCard(movie);
                },
              );
            } else if (state is NowPlayingSeriesError) {
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
