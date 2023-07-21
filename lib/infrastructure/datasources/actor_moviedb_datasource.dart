
import 'package:dio/dio.dart';

import '../mappers/actor_mapper.dart';
import '../../config/constants/environment.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';


class ActorMovieDbDatasource extends ActorsDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key' : Environment.theMovieDBkey,
      'language' : 'es-MX',
    }
  ));

  @override
  Future<List<Actor>> getActorByMovie(String movieId) async {

    final response = await dio.get(
      '/movie/$movieId/credits',
    );

    final creditsResponse = CreditsResponse.fromMap( response.data );

    final List<Actor> actors = creditsResponse.cast.map(
      (cast) => ActorMapper.castToEntity(cast)
    ).toList();

    return actors;

  }

}


