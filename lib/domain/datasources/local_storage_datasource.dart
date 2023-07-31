

import '../entities/movie.dart';

abstract class LocalStorageDatasource {

  Future<bool> toggleFavorite( Movie movie );

  Future<bool> isFavoriteMovie( int movieId ); 

  Future<List<Movie>> loadMovies({ int limit = 10, int offset = 0 }); 

}