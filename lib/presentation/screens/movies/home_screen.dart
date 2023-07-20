
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
  }

  @override
  Widget build(BuildContext context) {

    // Accesing to the state of the StateNotifierProvider and listen changes
    // final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return Column(
      children: [

        const CustomAppbar(),

        MoviesSlideshow(movies: slideShowMovies),
        
      ],
    );
  }
}