import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';

class GetNowPlayingSeries {
  final SeriesRepository repository;

  GetNowPlayingSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getNowPlayingSeries();
  }
}
