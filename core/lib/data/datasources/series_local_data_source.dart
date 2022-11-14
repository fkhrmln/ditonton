import '../../utils/exception.dart';
import 'db/database_series_helper.dart';
import '../models/series_table.dart';

abstract class SeriesLocalDataSource {
  Future<String> insertWatchlistSeries(SeriesTable series);
  Future<String> removeWatchlistSeries(SeriesTable series);
  Future<SeriesTable?> getSeriesById(int id);
  Future<List<SeriesTable>> getWatchlistSeries();
}

class SeriesLocalDataSourceImpl implements SeriesLocalDataSource {
  final DatabaseSeriesHelper databaseSeriesHelper;

  SeriesLocalDataSourceImpl({required this.databaseSeriesHelper});

  @override
  Future<String> insertWatchlistSeries(SeriesTable series) async {
    try {
      await databaseSeriesHelper.insertWatchlistSeries(series);
      return 'Added to Watchlist Series';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistSeries(SeriesTable series) async {
    try {
      await databaseSeriesHelper.removeWatchlistSeries(series);
      return 'Removed from Watchlist Series';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<SeriesTable?> getSeriesById(int id) async {
    final result = await databaseSeriesHelper.getSeriesById(id);
    if (result != null) {
      return SeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<SeriesTable>> getWatchlistSeries() async {
    final result = await databaseSeriesHelper.getWatchlistSeries();
    return result.map((data) => SeriesTable.fromMap(data)).toList();
  }
}
