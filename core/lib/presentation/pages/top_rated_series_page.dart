import 'package:core/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-series';

  @override
  _TopRatedSeriesPageState createState() => _TopRatedSeriesPageState();
}

class _TopRatedSeriesPageState extends State<TopRatedSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedSeriesBloc>().add(OnFetchTopRatedSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedSeriesBloc, TopRatedSeriesState>(
          builder: (context, state) {
            if (state is TopRatedSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedSeriesHasData) {
              final result = state.result;
              return ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final movie = result[index];

                  return SeriesCard(movie);
                },
              );
            } else if (state is TopRatedSeriesError) {
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
