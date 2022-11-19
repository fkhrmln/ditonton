import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movies_recommendation_event.dart';
part 'movies_recommendation_state.dart';

class MoviesRecommendationBloc
    extends Bloc<MoviesRecommendationEvent, MoviesRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MoviesRecommendationBloc(this._getMovieRecommendations)
      : super(MoviesRecommendationEmpty()) {
    on<OnFetchMoviesRecommendation>(
      (event, emit) async {
        final id = event.id;

        emit(MoviesRecommendationLoading());

        final result = await _getMovieRecommendations.execute(id);

        result.fold(
          (failure) {
            emit(MoviesRecommendationError(failure.message));
          },
          (data) {
            emit(MoviesRecommendationHasData(data));
          },
        );
      },
    );
  }
}
