import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  test('initial state should be empty', () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingMovies()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingMovies()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingMoviesLoading(),
  );
}
