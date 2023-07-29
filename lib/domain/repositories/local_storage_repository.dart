

import '../entities/movie.dart';

abstract class LocalStorageRepository {

  Future<void> toggleFavorite( Movie movie );

  Future<bool> isFavoriteMovie( int movieId ); 

  Future<List<Movie>> loadMovies({ int limit = 10, int offset = 0 }); 

}