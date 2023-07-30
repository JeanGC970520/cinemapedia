
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';

class IsarDatasource extends LocalStorageDatasource {
  @override
  Future<bool> isFavoriteMovie(int movieId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    throw UnimplementedError();
  }

}