
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import '../../domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query, { int page } ); 

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  // This stream can listen it to more than once
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  // Timer to do a manual debounce
  Timer? _debounceTimer;
  // To manage action's icons
  StreamController<bool> isLoadingStreamCtrl = StreamController.broadcast();


  void clearStreams() {
    debouncedMovies.close();
    // Must be canceled because when its being opened the search delegate,
    // its excecuted the buildSuggestions and inside is calling _onQueryChanged,
    // so the Timer is initializated and when close the search delegate, the
    // Timer be running.
    _debounceTimer?.cancel();
  }

  void _onQueryChanged( String query ) {
    // * NOTE: The functionality is, when the user writes a word,
    // *       canceling the Timer if its active. Then init the Timer
    // *       again and if pass 500 milliseconds without a user writes,
    // *       request the data.
    // print('Query String changed: $query');
    if( query.isNotEmpty ) isLoadingStreamCtrl.add(true);
    if( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      const Duration( milliseconds: 500 ), () async {
        // print('Searching movies');
        // Search movies and emit the stream with them.
        final movies = await searchMovies(query);
        isLoadingStreamCtrl.add(false);
        initialMovies = movies;
        debouncedMovies.add(movies);

      }
    );

  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieSearchItem(
              movie: movies[index],
              onMovieSelected: ( context, movie ) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }


  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {

    // print('query: $query');

    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStreamCtrl.stream,
        builder: (context, snapshot) {
          
          final isLoading = snapshot.data ?? false;

          return isLoading 
            ? SpinPerfect(
              spins: 10,
              infinite:  true,
              duration: const Duration(seconds: 20),
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon( Icons.refresh_rounded ),
              ),
            )
            : FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon( Icons.clear_rounded ),
              ),
            );

        },
      ),
    
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      }, 
      icon: const Icon( Icons.arrow_back_ios_new_rounded )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultsAndSuggestions();
  }

}

class _MovieSearchItem extends StatelessWidget {
  const _MovieSearchItem({
    required this.movie,
    required this.onMovieSelected,
  });

  final Movie movie;
  final Function onMovieSelected;

  @override
  Widget build(BuildContext context) {
    
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
    
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10,),
    
            // Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  Text(movie.title, style: textStyles.titleMedium,),
    
                  Text(
                    movie.overview, 
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox(width: 5,),
                      Text(
                        HumanFortmats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  ),
            
                ],
              ),
            )
    
          ],
        ),
      ),
    );
  }
}