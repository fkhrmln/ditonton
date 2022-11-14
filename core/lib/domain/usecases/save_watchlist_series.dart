import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../../domain/entities/series_detail.dart';
import '../../domain/repositories/series_repository.dart';

class SaveWatchListSeries {
  final SeriesRepository repository;

  SaveWatchListSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlistSeries(series);
  }
}
