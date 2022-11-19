import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'series_recommendation_event.dart';
part 'series_recommendation_state.dart';

class SeriesRecommendationBloc
    extends Bloc<SeriesRecommendationEvent, SeriesRecommendationState> {
  final GetSeriesRecommendations _getSeriesRecommendations;

  SeriesRecommendationBloc(this._getSeriesRecommendations)
      : super(SeriesRecommendationEmpty()) {
    on<OnFetchSeriesRecommedation>(
      (event, emit) async {
        final id = event.id;

        emit(SeriesRecommendationLoading());

        final result = await _getSeriesRecommendations.execute(id);

        result.fold(
          (failure) {
            emit(SeriesRecommendationError(failure.message));
          },
          (data) {
            emit(SeriesRecommendationHasData(data));
          },
        );
      },
    );
  }
}
