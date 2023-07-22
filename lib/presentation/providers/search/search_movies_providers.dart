

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import '../movies/movies_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');


final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {

  final movieRepository = ref.watch( movieRepositoryProvider );

  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies, 
    ref: ref
  );
}); 

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query, { int page });

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  
  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }): super([]);

  final SearchMoviesCallback searchMovies;
  final Ref ref;

  Future<List<Movie>> searchMoviesByQuery( String query, { int page = 1 } ) async {

    final List<Movie> movies = await searchMovies(query, page: page);
    ref.read( searchQueryProvider.notifier ).update((state) => query);

    state = movies;
    return movies;
  }

}

