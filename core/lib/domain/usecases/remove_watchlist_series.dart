import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../../domain/entities/series_detail.dart';
import '../../domain/repositories/series_repository.dart';

class RemoveWatchListSeries {
  final SeriesRepository repository;

  RemoveWatchListSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlistSeries(series);
  }
}
