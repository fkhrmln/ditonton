import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_series.dart';

part 'search_series_event.dart';
part 'search_series_state.dart';

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final SearchSeries _searchSeries;

  SearchSeriesBloc(this._searchSeries) : super(SearchSeriesEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        emit(SearchSeriesLoading());
        final result = await _searchSeries.execute(query);

        result.fold(
          (failure) {
            emit(SearchSeriesError(failure.message));
          },
          (data) {
            emit(SearchSeriesHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
