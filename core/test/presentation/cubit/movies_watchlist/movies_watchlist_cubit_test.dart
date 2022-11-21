import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/cubit/movies_watchlist/movies_watchlist_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movies_watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MoviesWatchlistCubit moviesWatchlistCubit;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    moviesWatchlistCubit = MoviesWatchlistCubit(
      mockGetWatchlistMovies,
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  test('initial state should be empty', () {
    expect(moviesWatchlistCubit.state, MoviesWatchlistEmpty());
  });

  blocTest<MoviesWatchlistCubit, MoviesWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return moviesWatchlistCubit;
    },
    act: (bloc) => moviesWatchlistCubit.fetchWatchlistMoveis(),
    expect: () => [
      MoviesWatchlistLoading(),
      MoviesWatchlistHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MoviesWatchlistCubit, MoviesWatchlistState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesWatchlistCubit;
    },
    act: (bloc) => moviesWatchlistCubit.fetchWatchlistMoveis(),
    expect: () => [
      MoviesWatchlistLoading(),
      MoviesWatchlistError('Server Failure'),
    ],
    verify: (bloc) => MoviesWatchlistLoading(),
  );
}
