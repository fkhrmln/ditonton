import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/presentation/cubit/series_watchlist/series_watchlist_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'series_watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlistSeries,
  GetWatchListSeriesStatus,
  SaveWatchListSeries,
  RemoveWatchListSeries,
])
void main() {
  late MockGetWatchlistSeries mockGetWatchlistSeries;
  late MockGetWatchListSeriesStatus mockGetWatchListSeriesStatus;
  late MockSaveWatchListSeries mockSaveWatchListSeries;
  late MockRemoveWatchListSeries mockRemoveWatchListSeries;
  late SeriesWatchlistCubit seriesWatchlistCubit;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    mockGetWatchListSeriesStatus = MockGetWatchListSeriesStatus();
    mockSaveWatchListSeries = MockSaveWatchListSeries();
    mockRemoveWatchListSeries = MockRemoveWatchListSeries();
    seriesWatchlistCubit = SeriesWatchlistCubit(
      mockGetWatchlistSeries,
      mockGetWatchListSeriesStatus,
      mockSaveWatchListSeries,
      mockRemoveWatchListSeries,
    );
  });

  test('initial state should be empty', () {
    expect(seriesWatchlistCubit.state, SeriesWatchlistEmpty());
  });

  blocTest<SeriesWatchlistCubit, SeriesWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return seriesWatchlistCubit;
    },
    act: (bloc) => seriesWatchlistCubit.fetchWatchlistSeries(),
    expect: () => [
      SeriesWatchlistLoading(),
      SeriesWatchlistHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistSeries.execute());
    },
  );

  blocTest<SeriesWatchlistCubit, SeriesWatchlistState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesWatchlistCubit;
    },
    act: (bloc) => seriesWatchlistCubit.fetchWatchlistSeries(),
    expect: () => [
      SeriesWatchlistLoading(),
      SeriesWatchlistError('Server Failure'),
    ],
    verify: (bloc) => SeriesWatchlistLoading(),
  );
}
