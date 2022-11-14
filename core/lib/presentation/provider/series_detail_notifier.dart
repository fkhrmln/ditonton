import '../../utils/state_enum.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/series_detail.dart';
import '../../domain/usecases/get_series_detail.dart';
import '../../domain/usecases/get_series_recommendations.dart';
import '../../domain/usecases/get_watchlist_series_status.dart';
import '../../domain/usecases/remove_watchlist_series.dart';
import '../../domain/usecases/save_watchlist_series.dart';
import 'package:flutter/widgets.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist Series';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist Series';

  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final GetWatchListSeriesStatus getWatchListSeriesStatus;
  final SaveWatchListSeries saveWatchListSeries;
  final RemoveWatchListSeries removeWatchListSeries;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
    required this.getWatchListSeriesStatus,
    required this.saveWatchListSeries,
    required this.removeWatchListSeries,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _seriesRecommendationsState = RequestState.Empty;
  RequestState get seriesRecommendationsState => _seriesRecommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlistSeries = false;
  bool get isAddedToWatchlistSeries => _isAddedToWatchlistSeries;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getSeriesDetail.execute(id);
    final seriesRecommendationsResult = await getSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (serie) {
        _seriesState = RequestState.Loading;
        _series = serie;
        notifyListeners();
        seriesRecommendationsResult.fold(
          (failure) {
            _seriesRecommendationsState = RequestState.Error;
            _message = failure.message;
          },
          (series) {
            _seriesRecommendationsState = RequestState.Loaded;
            _seriesRecommendations = series;
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistSeriesMessage = '';
  String get watchlistSeriesMessage => _watchlistSeriesMessage;

  Future<void> addWatchlistSeries(SeriesDetail series) async {
    final result = await saveWatchListSeries.execute(series);

    await result.fold(
      (failure) async {
        _watchlistSeriesMessage = failure.message;
      },
      (successMessage) async {
        _watchlistSeriesMessage = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }

  Future<void> removeFromWatchlistSeries(SeriesDetail series) async {
    final result = await removeWatchListSeries.execute(series);

    await result.fold(
      (failure) async {
        _watchlistSeriesMessage = failure.message;
      },
      (successMessage) async {
        _watchlistSeriesMessage = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }

  Future<void> loadWatchlistSeriesStatus(int id) async {
    final result = await getWatchListSeriesStatus.execute(id);
    _isAddedToWatchlistSeries = result;
    notifyListeners();
  }
}
