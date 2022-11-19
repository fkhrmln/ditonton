import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/bloc/popular_series/popular_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  test('initial state should be empty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopularMovies()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(OnFetchPopularMovies()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (bloc) => PopularSeriesLoading(),
  );
}
