
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'actors_repository_provider.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

/*
    General idea of function

Syntax: { 'id' : List<Actor> }
{

  '505642' : <Actor>[],
  '505643' : <Actor>[],
  '505645' : <Actor>[],
  '505226' : <Actor>[],
  '505649' : <Actor>[],

}

*/

final actorsByMovieProvider = StateNotifierProvider< ActorsByMovieNotifier, Map<String,List<Actor>> >(
  (ref) {
    final actorsRespository = ref.watch( actorsRepositoryProvider );

    return ActorsByMovieNotifier( getActors: actorsRespository.getActorByMovie );
  }
);


typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

// Notifier. Controll the state.
class ActorsByMovieNotifier extends StateNotifier<Map<String,List<Actor>>> {
  
  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({});

  final GetActorsCallback getActors;

  Future<void> loadActors( String movieId ) async {

    // If the actors info is in cache, not requesting it
    if( state[movieId] != null ) return;
    // print('Realizando peticion HTTP');
    final List<Actor> actors = await getActors( movieId );

    state = { ...state, movieId : actors };

  }

}
