import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movies_watchlist_state.dart';

class MoviesWatchlistCubit extends Cubit<MoviesWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  String message = '';

  MoviesWatchlistCubit(this._getWatchlistMovies, this._getWatchListStatus,
      this._saveWatchlist, this._removeWatchlist)
      : super(MoviesWatchlistEmpty());

  Future<void> fetchWatchlistMoveis() async {
    emit(MoviesWatchlistLoading());

    final result = await _getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(MoviesWatchlistError(failure.message));
      },
      (data) {
        emit(MoviesWatchlistHasData(data));
      },
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await _getWatchListStatus.execute(id);

    result
        ? message = watchlistAddSuccessMessage
        : message = watchlistRemoveSuccessMessage;

    emit(MoviesWatchlistIsAdedd(result));
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await _saveWatchlist.execute(movie);

    result.fold(
      (failure) {
        emit(MoviesWatchlistIsAdedd(false));
        message = failure.message;
      },
      (successMessage) {
        emit(MoviesWatchlistIsAdedd(true));
        message = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeWatchlist(MovieDetail movie) async {
    final result = await _removeWatchlist.execute(movie);

    result.fold(
      (failure) {
        emit(MoviesWatchlistIsAdedd(true));
        message = failure.message;
      },
      (successMessage) {
        emit(MoviesWatchlistIsAdedd(false));
        message = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }
}
