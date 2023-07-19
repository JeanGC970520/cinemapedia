
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

import 'package:cinemapedia/infrastructure/datasources/the_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/respositories/movie_repository_impl.dart';

// Here is where I could change the datasource
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl( TheMovieDbDatasource() );
});