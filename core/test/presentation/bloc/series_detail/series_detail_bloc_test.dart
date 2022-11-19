import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_series_detail.dart';
import 'package:core/presentation/bloc/series_detail/series_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'series_detail_bloc_test.mocks.dart';

@GenerateMocks([GetSeriesDetail])
void main() {
  late MockGetSeriesDetail mockGetSeriesDetail;
  late SeriesDetailBloc seriesDetailBloc;

  const id = 1;

  setUp(() {
    mockGetSeriesDetail = MockGetSeriesDetail();
    seriesDetailBloc = SeriesDetailBloc(mockGetSeriesDetail);
  });

  test('initial state should be empty', () {
    expect(seriesDetailBloc.state, SeriesDetailEmpty());
  });

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSeriesDetail.execute(id))
          .thenAnswer((_) async => Right(testSeriesDetail));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchSeriesDetail(id)),
    expect: () => [
      SeriesDetailLoading(),
      SeriesDetailHasData(testSeriesDetail),
    ],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(id));
    },
  );

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetSeriesDetail.execute(id))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(OnFetchSeriesDetail(id)),
    expect: () => [
      SeriesDetailLoading(),
      SeriesDetailError('Server Failure'),
    ],
    verify: (bloc) => SeriesDetailLoading(),
  );
}
