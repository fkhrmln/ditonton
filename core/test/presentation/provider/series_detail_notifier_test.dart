import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_series_detail.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/presentation/provider/series_detail_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetSeriesDetail,
  GetSeriesRecommendations,
  GetWatchListSeriesStatus,
  SaveWatchListSeries,
  RemoveWatchListSeries,
])
void main() {
  late SeriesDetailNotifier provider;
  late MockGetSeriesDetail mockGetSeriesDetail;
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late MockGetWatchListSeriesStatus mockGetWatchListSeriesStatus;
  late MockSaveWatchListSeries mockSaveWatchListSeries;
  late MockRemoveWatchListSeries mockRemoveWatchListSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSeriesDetail = MockGetSeriesDetail();
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    mockGetWatchListSeriesStatus = MockGetWatchListSeriesStatus();
    mockSaveWatchListSeries = MockSaveWatchListSeries();
    mockRemoveWatchListSeries = MockRemoveWatchListSeries();
    provider = SeriesDetailNotifier(
      getSeriesDetail: mockGetSeriesDetail,
      getSeriesRecommendations: mockGetSeriesRecommendations,
      getWatchListSeriesStatus: mockGetWatchListSeriesStatus,
      saveWatchListSeries: mockSaveWatchListSeries,
      removeWatchListSeries: mockRemoveWatchListSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tSerie = Series(
    backdropPath: "/5vUux2vNUTqwCzb7tVcH18XnsF.jpg",
    genreIds: [18, 80],
    id: 113988,
    name: "Dahmer – Monster: The Jeffrey Dahmer Story",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Dahmer – Monster: The Jeffrey Dahmer Story",
    overview:
        "Across more than a decade, 17 teen boys and young men were murdered by convicted killer Jeffrey Dahmer. How did he evade arrest for so long?",
    popularity: 3037.8,
    posterPath: "/qAv0UoAQVZWd6HGc83fsli1aKmo.jpg",
    voteAverage: 8.3,
    voteCount: 1192,
  );
  final tSeries = <Series>[tSerie];

  void _arrangeUsecase() {
    when(mockGetSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testSeriesDetail));
    when(mockGetSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tSeries));
  }

  group('Get Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      verify(mockGetSeriesDetail.execute(tId));
      verify(mockGetSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change series when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.series, testSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation series when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.seriesRecommendations, tSeries);
    });
  });

  group('Get Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      verify(mockGetSeriesRecommendations.execute(tId));
      expect(provider.seriesRecommendations, tSeries);
    });

    test('should update recommendation state when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesRecommendationsState, RequestState.Loaded);
      expect(provider.seriesRecommendations, tSeries);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testSeriesDetail));
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesRecommendationsState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist series status', () async {
      // arrange
      when(mockGetWatchListSeriesStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistSeriesStatus(1);
      // assert
      expect(provider.isAddedToWatchlistSeries, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchListSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistSeries(testSeriesDetail);
      // assert
      verify(mockSaveWatchListSeries.execute(testSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchListSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlistSeries(testSeriesDetail);
      // assert
      verify(mockRemoveWatchListSeries.execute(testSeriesDetail));
    });

    test('should update watchlist series status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchListSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistSeries(testSeriesDetail);
      // assert
      verify(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id));
      expect(provider.isAddedToWatchlistSeries, true);
      expect(provider.watchlistSeriesMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchListSeries.execute(testSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlistSeries(testSeriesDetail);
      // assert
      expect(provider.watchlistSeriesMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tSeries));
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
