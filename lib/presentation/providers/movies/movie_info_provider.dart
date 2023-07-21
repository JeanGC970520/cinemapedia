import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

/*
    General idea of function

Syntax: { 'id' : Movie instance }
{

  '505642' : Movie(),
  '505643' : Movie(),
  '505645' : Movie(),
  '505226' : Movie(),
  '505649' : Movie(),

}

*/

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String,Movie>>(
  (ref) {
    final movieRepository = ref.watch( movieRepositoryProvider );

    return MovieMapNotifier(getMovie: movieRepository.getMovieById);
  }
);


typedef GetMovieCallback = Future<Movie> Function(String movieId);

// Notifier. Controll the state.
class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  
  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  final GetMovieCallback getMovie;

  Future<void> loadMovie( String movieId ) async {

    // If the movie info is in cache, not requesting it
    if( state[movieId] != null ) return;
    // print('Realizando peticion HTTP');
    final movie = await getMovie( movieId );

    state = { ...state, movieId : movie };

  }

}
