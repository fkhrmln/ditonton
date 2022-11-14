import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_now_playing_series.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/presentation/provider/now_playing_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'series_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries])
void main() {
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;
  late NowPlayingSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    notifier = NowPlayingSeriesNotifier(mockGetNowPlayingSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tSeries = Series(
    backdropPath: "backdropPath",
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ["originCountry"],
    originalLanguage: "originalLanguage",
    originalName: "OriginalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tSeriesList = <Series>[tSeries];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingSeries.execute()).thenAnswer((_) async => Right(tSeriesList));
    // act
    notifier.fetchNowPlayingSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change series data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingSeries.execute()).thenAnswer((_) async => Right(tSeriesList));
    // act
    await notifier.fetchNowPlayingSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.series, tSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
