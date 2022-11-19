import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/get_now_playing_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_series_event.dart';
part 'now_playing_series_state.dart';

class NowPlayingSeriesBloc extends Bloc<NowPlayingSeriesEvent, NowPlayingSeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;
  NowPlayingSeriesBloc(this._getNowPlayingSeries) : super(NowPlayingSeriesEmpty()) {
    on<OnFetchNowPlayingSeries>(
      (event, emit) async {
        emit(NowPlayingSeriesLoading());

        final result = await _getNowPlayingSeries.execute();

        result.fold(
          (failure) {
            emit(NowPlayingSeriesError(failure.message));
          },
          (data) {
            emit(NowPlayingSeriesHasData(data));
          },
        );
      },
    );
  }
}
