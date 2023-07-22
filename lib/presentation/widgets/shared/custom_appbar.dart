
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import '../../delegates/search_movie_delegate.dart';
import '../../providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
      
              Icon( Icons.movie_outlined, color: colors.primary, ),
              const SizedBox(width: 5,),
      
              Text('Cinemapedia', style: titleStyle,),
      
              const Spacer(),
              IconButton(
                onPressed: () {

                  final movieRepository = ref.read( movieRepositoryProvider );
                  final searchQuery = ref.read( searchQueryProvider );

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context, 
                    delegate: SearchMovieDelegate(
                      searchMovies: (String query, { int page=1 }) {
                        ref.read( searchQueryProvider.notifier ).update((state) => query);
                        return movieRepository.searchMovies(query);
                      } ,
                    ),
                  ).then((movie) {
                    if( movie == null ) return; 

                    context.push('/movie/${movie.id}');
                  });
                  // * NOTE: Use then() to do something after the 
                  // * future finished. So I can use the context and the Movie instance.
                  // * I haven't to use async function. 

                },
                icon: const Icon(Icons.search),
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}