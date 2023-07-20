
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const name = "home-screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {


  @override
  void initState() {
    super.initState();
    // Accesing to the notifier(controller) of the StateNotifierProvider
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if( initialLoading ) return const FullScreenLoader();

    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    // Accesing to the state of the StateNotifierProvider and listen changes
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            // * NOTE: It seems that when using the FlexibleSpaceBar, 
            // *       the title property comes with a default padding.
            // *       So, I remove it to display my CustomAppbar widget
            // centerTitle: true,
            titlePadding: EdgeInsets.zero,
            title: CustomAppbar(),
          ),
        ),

        // * Used the SliverList like a special container to display the 
        // * content inside of CustomScrollView.
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
            
                  // const CustomAppbar(),
            
                  MoviesSlideshow(movies: slideShowMovies),
            
                  MovieHorizontalListview( 
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Lunes 20',
                    loadNextPage: () {
                      ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListview( 
                    movies: upcomingMovies,
                    title: 'Proximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () {
                      ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListview( 
                    movies: popularMovies,
                    title: 'Populares',
                    // subTitle: 'En este mes',
                    loadNextPage: () {
                      ref.read( popularMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListview( 
                    movies: topRatedMovies,
                    title: 'Mejor calificadas',
                    subTitle: 'Desde siempre',
                    loadNextPage: () {
                      ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
                  
                ],
              );
            },
            childCount: 1,
          ),
        ),

      ]
    );
  }
}