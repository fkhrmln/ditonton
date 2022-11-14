import '../../utils/state_enum.dart';
import '../../utils/utils.dart';
import '../../presentation/provider/watchlist_series_notifier.dart';
import '../../presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchListSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-series';

  @override
  _WatchListSeriesPageState createState() => _WatchListSeriesPageState();
}

class _WatchListSeriesPageState extends State<WatchListSeriesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<WatchlistSeriesNotifier>(context, listen: false)
        .fetchWatchlistSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistSeriesNotifier>(context, listen: false).fetchWatchlistSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistSeriesNotifier>(
          builder: (context, data, child) {
            if (data.watchlistSeriesState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final serie = data.watchlistSeries[index];
                  return SeriesCard(serie);
                },
                itemCount: data.watchlistSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
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
