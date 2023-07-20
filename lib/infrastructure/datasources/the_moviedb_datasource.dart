import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class TheMovieDbDatasource extends MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key' : Environment.theMovieDBkey,
      'language' : 'es-MX',
    }
  ));

  @override
  Future<List<Movie>> getNowPLaying({int page = 1}) async {

    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page' : page,
      }
    );

    final movieDBResponse = MovieDbResponse.fromMap(response.data);
    // the where() method filters the moviedb where it has no poster 
    // and doesn't use it to pass it to the map() method 
    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster')
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;
  }
}