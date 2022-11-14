import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_series.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';

import '../provider/series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late SearchSeriesBloc searchBloc;
  late MockSearchSeries mockSearchSeries;

  setUp(() {
    mockSearchSeries = MockSearchSeries();
    searchBloc = SearchSeriesBloc(mockSearchSeries);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchSeriesEmpty());
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

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchSeries.execute(tQuery)).thenAnswer((_) async => Right(tSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchSeriesLoading(),
      SearchSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchSeriesLoading(),
      const SearchSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );
}
