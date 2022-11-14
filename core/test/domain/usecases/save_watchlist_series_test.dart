import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchListSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SaveWatchListSeries(mockSeriesRepository);
  });

  test('should save series to the repository', () async {
    // arrange
    when(mockSeriesRepository.saveWatchlistSeries(testSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist Series'));
    // act
    final result = await usecase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.saveWatchlistSeries(testSeriesDetail));
    expect(result, Right('Added to Watchlist Series'));
  });
}
