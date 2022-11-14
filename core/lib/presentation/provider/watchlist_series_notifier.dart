import '../../utils/state_enum.dart';
import '../../domain/entities/series.dart';
import '../../domain/usecases/get_watchlist_series.dart';
import 'package:flutter/widgets.dart';

class WatchlistSeriesNotifier extends ChangeNotifier {
  var _watchlistSeries = <Series>[];
  List<Series> get watchlistSeries => _watchlistSeries;

  var _watchlistSeriesState = RequestState.Empty;
  RequestState get watchlistSeriesState => _watchlistSeriesState;

  String _message = '';
  String get message => _message;

  WatchlistSeriesNotifier({required this.getWatchlistSeries});

  final GetWatchlistSeries getWatchlistSeries;

  Future<void> fetchWatchlistSeries() async {
    _watchlistSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistSeries.execute();

    result.fold(
      (failure) {
        _watchlistSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _watchlistSeriesState = RequestState.Loaded;
        _watchlistSeries = seriesData;
        notifyListeners();
      },
    );
  }
}
