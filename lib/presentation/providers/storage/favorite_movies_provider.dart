
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


/* Data structure

  {
    1234 : Movie,
    2344 : Movie,
    2341 : Movie,
  }

*/

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {

  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({
    required this.localStorageRepository,
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for( final movie in movies ) {
      tempMoviesMap[movie.id] = movie;
    }

    state = { ...state, ...tempMoviesMap };

    return movies;
  }

}