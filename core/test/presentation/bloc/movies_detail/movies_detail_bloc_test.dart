import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/presentation/bloc/movies_detail/movies_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movies_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MoviesDetailBloc moviesDetailBloc;

  const id = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    moviesDetailBloc = MoviesDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(moviesDetailBloc.state, MoviesDetailEmpty());
  });

  blocTest<MoviesDetailBloc, MoviesDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(id))
          .thenAnswer((_) async => Right(testMovieDetail));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesDetail(id)),
    expect: () => [
      MoviesDetailLoading(),
      MoviesDetailHasData(testMovieDetail),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(id));
    },
  );

  blocTest<MoviesDetailBloc, MoviesDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchMoviesDetail(id)),
    expect: () => [
      MoviesDetailLoading(),
      MoviesDetailError('Server Failure'),
    ],
    verify: (bloc) => MoviesDetailLoading(),
  );
}
