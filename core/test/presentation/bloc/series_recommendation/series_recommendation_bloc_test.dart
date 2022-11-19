import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:core/presentation/bloc/series_recommendation/series_recommendation_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'series_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetSeriesRecommendations])
void main() {
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late SeriesRecommendationBloc seriesRecommendationBloc;

  const id = 1;

  setUp(() {
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    seriesRecommendationBloc = SeriesRecommendationBloc(mockGetSeriesRecommendations);
  });

  test('initial state should be empty', () {
    expect(seriesRecommendationBloc.state, SeriesRecommendationEmpty());
  });

  blocTest<SeriesRecommendationBloc, SeriesRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Right(testSeriesList));
      return seriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(OnFetchSeriesRecommedation(id)),
    expect: () => [
      SeriesRecommendationLoading(),
      SeriesRecommendationHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(id));
    },
  );

  blocTest<SeriesRecommendationBloc, SeriesRecommendationState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesRecommendationBloc;
    },
    act: (bloc) => bloc.add(OnFetchSeriesRecommedation(id)),
    expect: () => [
      SeriesRecommendationLoading(),
      SeriesRecommendationError('Server Failure'),
    ],
    verify: (bloc) => SeriesRecommendationLoading(),
  );
}
