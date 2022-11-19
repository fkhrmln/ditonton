import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movies_detail_event.dart';
part 'movies_detail_state.dart';

class MoviesDetailBloc extends Bloc<MoviesDetailEvent, MoviesDetailState> {
  final GetMovieDetail _getMovieDetail;

  MoviesDetailBloc(this._getMovieDetail) : super(MoviesDetailEmpty()) {
    on<OnFetchMoviesDetail>(
      (event, emit) async {
        final id = event.id;

        emit(MoviesDetailLoading());

        final result = await _getMovieDetail.execute(id);

        result.fold(
          (failure) {
            emit(MoviesDetailError(failure.message));
          },
          (data) {
            emit(MoviesDetailHasData(data));
          },
        );
      },
    );
  }
}
