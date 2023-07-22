
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import '../../domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query, { int page } ); 

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  SearchMovieDelegate({
    required this.searchMovies,
  });

  SearchMoviesCallback searchMovies;

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {

    // print('query: $query');

    return [
      
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon( Icons.clear_rounded ),
        ),
      ),
    
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon( Icons.arrow_back_ios_new_rounded )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('build results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchMovies(query),
      // initialData: const <Movie>[],
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieSearchItem(
              movie: movies[index],
              onMovieSelected: close,
            );
          },
        );
      },
    );
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