import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_popular_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'popular_series_event.dart';
part 'popular_series_state.dart';

class PopularSeriesBloc extends Bloc<PopularSeriesEvent, PopularSeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(PopularSeriesEmpty()) {
    on<OnFetchPopularSeries>(
      (event, emit) async {
        emit(PopularSeriesLoading());

        final result = await _getPopularSeries.execute();

        result.fold(
          (failure) {
            emit(PopularSeriesError(failure.message));
          },
          (data) {
            emit(PopularSeriesHasData(data));
          },
        );
      },
    );
  }
}
