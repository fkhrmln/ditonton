import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/series_detail/series_detail_bloc.dart';
import 'package:core/presentation/bloc/series_recommendation/series_recommendation_bloc.dart';
import 'package:core/presentation/cubit/series_watchlist/series_watchlist_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/series_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-series';

  final int id;
  SeriesDetailPage({required this.id, Key? key}) : super(key: key);

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SeriesDetailBloc>().add(OnFetchSeriesDetail(widget.id));
      context.read<SeriesRecommendationBloc>().add(OnFetchSeriesRecommedation(widget.id));
      context.read<SeriesWatchlistCubit>().loadWatchlistSeriesStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
        builder: (context, detail) {
          if (detail is SeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (detail is SeriesDetailHasData) {
            final series = detail.result;

            return BlocBuilder<SeriesRecommendationBloc, SeriesRecommendationState>(
              builder: (context, recommendation) {
                if (recommendation is SeriesRecommendationLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (recommendation is SeriesRecommendationHasData) {
                  return BlocBuilder<SeriesWatchlistCubit, SeriesWatchlistState>(
                    builder: (context, state) {
                      if (state is SeriesWatchlistIsAdedd) {
                        return SafeArea(
                          child: DetailContentSeries(
                            series,
                            recommendation.result,
                            state.isAdded,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else if (recommendation is SeriesRecommendationError) {
                  return Center(
                    child: Text(recommendation.message),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (detail is SeriesDetailError) {
            return Center(
              child: Text(detail.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContentSeries extends StatelessWidget {
  final SeriesDetail series;
  final List<Series> recommendations;
  final bool isAddedWatchlistSeries;

  DetailContentSeries(
    this.series,
    this.recommendations,
    this.isAddedWatchlistSeries,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlistSeries) {
                                  await context
                                      .read<SeriesWatchlistCubit>()
                                      .addWatchlistSeries(series);
                                } else {
                                  await context
                                      .read<SeriesWatchlistCubit>()
                                      .removeWatchlistSeries(series);
                                }

                                final message =
                                    context.read<SeriesWatchlistCubit>().message;

                                if (message == watchlistAddSuccessMessage ||
                                    message == watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlistSeries
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(series.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: series.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final serie = recommendations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          SeriesDetailPage.ROUTE_NAME,
                                          arguments: serie.id,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${serie.posterPath}',
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
