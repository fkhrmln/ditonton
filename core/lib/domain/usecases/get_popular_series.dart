import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';

class GetPopularSeries {
  final SeriesRepository repository;

  GetPopularSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getPopularSeries();
  }
}
