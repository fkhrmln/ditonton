import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/presentation/bloc/movies_recommendation/movies_recommendation_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movies_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MoviesRecommendationBloc moviesRecommendationBloc;

  const id = 1;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    moviesRecommendationBloc = MoviesRecommendationBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(moviesRecommendationBloc.state, MoviesRecommendationEmpty());
  });

  blocTest<MoviesRecommendationBloc, MoviesRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(id))
          .thenAnswer((_) async => Right(testMovieList));
      return moviesRecommendationBloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesRecommendation(id)),
    expect: () => [
      MoviesRecommendationLoading(),
      MoviesRecommendationHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(id));
    },
  );

  blocTest<MoviesRecommendationBloc, MoviesRecommendationState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesRecommendationBloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesRecommendation(id)),
    expect: () => [
      MoviesRecommendationLoading(),
      MoviesRecommendationError('Server Failure'),
    ],
    verify: (bloc) => MoviesRecommendationLoading(),
  );
}
