import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_top_rated_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top_rated_series_event.dart';
part 'top_rated_series_state.dart';

class TopRatedSeriesBloc extends Bloc<TopRatedSeriesEvent, TopRatedSeriesState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesBloc(this._getTopRatedSeries) : super(TopRatedSeriesEmpty()) {
    on<OnFetchTopRatedSeries>(
      (event, emit) async {
        emit(TopRatedSeriesLoading());

        final result = await _getTopRatedSeries.execute();

        result.fold(
          (failure) {
            emit(TopRatedSeriesError(failure.message));
          },
          (data) {
            emit(TopRatedSeriesHasData(data));
          },
        );
      },
    );
  }
}
