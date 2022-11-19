import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_now_playing_series.dart';
import 'package:core/presentation/bloc/now_playing_series/now_playing_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries])
void main() {
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;
  late NowPlayingSeriesBloc nowPlayingSeriesBloc;

  setUp(() {
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    nowPlayingSeriesBloc = NowPlayingSeriesBloc(mockGetNowPlayingSeries);
  });

  test('initial state should be empty', () {
    expect(nowPlayingSeriesBloc.state, NowPlayingSeriesEmpty());
  });

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingSeries()),
    expect: () => [
      NowPlayingSeriesLoading(),
      NowPlayingSeriesHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingSeries.execute());
    },
  );

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(OnFetchNowPlayingSeries()),
    expect: () => [
      NowPlayingSeriesLoading(),
      NowPlayingSeriesError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingSeriesLoading(),
  );
}
