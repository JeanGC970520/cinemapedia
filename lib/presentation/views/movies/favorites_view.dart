
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    
    loadNextPage();
  }

  void loadNextPage() async {

    if( isLoading || isLastPage ) return; 
    isLoading = true;
    
    // Load the favorite movies of any datasource that has used
    final movies = await ref.read( favoriteMoviesProvider.notifier ).loadNextPage();
    isLoading = false;

    if( movies.isEmpty ) {
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    final favoriteMoviesMap = ref.watch( favoriteMoviesProvider );
    final favoriteMovies = favoriteMoviesMap.values.toList();

    return Scaffold(
      body: MovieMasonry(
        movies: favoriteMovies, 
        loadNextPage: loadNextPage,
      ),
    );
  }
}