import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/entities/series_detail.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'series_watchlist_state.dart';

class SeriesWatchlistCubit extends Cubit<SeriesWatchlistState> {
  final GetWatchlistSeries _getWatchlistSeries;
  final GetWatchListSeriesStatus _getWatchListSeriesStatus;
  final SaveWatchListSeries _saveWatchListSeries;
  final RemoveWatchListSeries _removeWatchListSeries;

  String message = '';

  SeriesWatchlistCubit(this._getWatchlistSeries, this._getWatchListSeriesStatus,
      this._saveWatchListSeries, this._removeWatchListSeries)
      : super(SeriesWatchlistEmpty());

  Future<void> fetchWatchlistSeries() async {
    emit(SeriesWatchlistLoading());

    final result = await _getWatchlistSeries.execute();

    result.fold(
      (failure) {
        emit(SeriesWatchlistError(failure.message));
      },
      (data) {
        emit(SeriesWatchlistHasData(data));
      },
    );
  }

  Future<void> loadWatchlistSeriesStatus(int id) async {
    final result = await _getWatchListSeriesStatus.execute(id);

    result
        ? message = watchlistAddSuccessMessage
        : message = watchlistRemoveSuccessMessage;

    emit(SeriesWatchlistIsAdedd(result));
  }

  Future<void> addWatchlistSeries(SeriesDetail series) async {
    final result = await _saveWatchListSeries.execute(series);

    result.fold(
      (failure) {
        emit(SeriesWatchlistIsAdedd(false));
        message = failure.message;
      },
      (successMessage) {
        emit(SeriesWatchlistIsAdedd(true));
        message = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }

  Future<void> removeWatchlistSeries(SeriesDetail series) async {
    final result = await _removeWatchListSeries.execute(series);

    result.fold(
      (failure) {
        emit(SeriesWatchlistIsAdedd(true));
        message = failure.message;
      },
      (successMessage) {
        emit(SeriesWatchlistIsAdedd(false));
        message = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }
}
