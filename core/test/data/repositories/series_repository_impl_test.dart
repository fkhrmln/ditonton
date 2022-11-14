import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/data/models/series_detail_model.dart';
import 'package:core/data/models/series_model.dart';
import 'package:core/data/repositories/series_repository_impl.dart';
import 'package:core/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl repository;
  late MockSeriesRemoteDataSource mockRemoteDataSource;
  late MockSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockSeriesRemoteDataSource();
    mockLocalDataSource = MockSeriesLocalDataSource();
    repository = SeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tSeriesModel = SeriesModel(
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

  final tSeries = Series(
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

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group('Now Playing Series', () {
    test('should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.getNowPlayingSeries();
      // assert
      verify(mockRemoteDataSource.getNowPlayingSeries());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingSeries()).thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingSeries();
      // assert
      verify(mockRemoteDataSource.getNowPlayingSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingSeries();
      // assert
      verify(mockRemoteDataSource.getNowPlayingSeries());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Series', () {
    test('should return series list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.getPopularSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularSeries();
      // assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Series', () {
    test('should return series list when call to data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedSeries();
      // assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Series Detail', () {
    final tId = 1;
    final tSeriesResponse = SeriesDetailResponse(
      adult: false,
      backdropPath: "backdropPath",
      episodeRunTime: [60],
      genres: [
        GenreModel(
          id: 1,
          name: "Drama",
        )
      ],
      id: 1,
      name: "name",
      overview: "overview",
      popularity: 1.0,
      posterPath: "posterPath",
      voteAverage: 1.0,
      voteCount: 1,
    );

    test('should return Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenAnswer((_) async => tSeriesResponse);
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Right(testSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Series Recommendations', () {
    final tSeriesList = <SeriesModel>[];
    final tId = 1;

    test('should return data (series list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenAnswer((_) async => tSeriesList);
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tSeriesList));
    });

    test('should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Series', () {
    final tQuery = 'dahmer';

    test('should return series list when call to data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist series', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist Series');
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist Series'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist Series', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist Series');
      // act
      final result = await repository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Right('Removed from Watchlist Series'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist series status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistSeries(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist series', () {
    test('should return list of Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistSeries())
          .thenAnswer((_) async => [testSeriesTable]);
      // act
      final result = await repository.getWatchlistSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistSeries]);
    });
  });
}
