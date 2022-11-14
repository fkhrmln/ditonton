import 'package:core/domain/entities/series.dart';
import 'package:search/domain/usecases/search_series.dart';
import 'package:search/presentation/provider/series_search_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late SeriesSearchNotifier provider;
  late MockSearchSeries mockSearchSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchSeries = MockSearchSeries();
    provider = SeriesSearchNotifier(searchSeries: mockSearchSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tSeriesModel = Series(
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

  final tSeriesList = <Series>[tSeriesModel];
  const tQuery = 'dahmer';

  group('search series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchSeries.execute(tQuery)).thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully', () async {
      // arrange
      when(mockSearchSeries.execute(tQuery)).thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
