

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

// Syntax of StateNotifierProvider => StateNotifierProvider<Notifier<T>, T>()
// When T is the state type
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPLaying;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

// * NOTE: Using the same StateNotifierProvider but with a different use cases
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopRated;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});



// Defining function signature
typedef MovieCallback = Future<List<Movie>> Function({ int page });

class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;
  
  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  Future<void> loadNextPage() async {
    if( isLoading ) return;

    isLoading = true;
    // print('LOad movies');
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    // This delayed only is used to await movies rendering 
    // and prevent a second request during it
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }

}



