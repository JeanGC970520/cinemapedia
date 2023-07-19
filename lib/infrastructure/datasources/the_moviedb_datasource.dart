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

    final response = await dio.get('/movie/now_playing');
    final List<Movie> movies = [];

    return movies;
  }
}