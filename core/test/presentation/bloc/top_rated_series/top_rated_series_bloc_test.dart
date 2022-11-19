import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_top_rated_series.dart';
import 'package:core/presentation/bloc/top_rated_series/top_rated_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedSeries])
void main() {
  late MockGetTopRatedSeries mockGetTopRatedSeries;
  late TopRatedSeriesBloc topRatedSeriesBloc;

  setUp(() {
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    topRatedSeriesBloc = TopRatedSeriesBloc(mockGetTopRatedSeries);
  });

  test('initial state should be empty', () {
    expect(topRatedSeriesBloc.state, TopRatedSeriesEmpty());
  });

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRatedSeries()),
    expect: () => [
      TopRatedSeriesLoading(),
      TopRatedSeriesHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
    },
  );

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(OnFetchTopRatedSeries()),
    expect: () => [
      TopRatedSeriesLoading(),
      TopRatedSeriesError('Server Failure'),
    ],
    verify: (bloc) => TopRatedSeriesLoading(),
  );
}
