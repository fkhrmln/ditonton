import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  // MovieRemoteDataSource,
  // MovieLocalDataSource,
  // DatabaseHelper,
  SeriesRepository,
  // SeriesRemoteDataSource,
  // SeriesLocalDataSource,
  // DatabaseSeriesHelper
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
