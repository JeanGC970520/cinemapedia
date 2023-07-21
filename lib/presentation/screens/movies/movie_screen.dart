
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  const MovieScreen({
    super.key,
    required this.movieId,
  });

  final String movieId;

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    // Calling method to request movie by id if it is not in cache
    ref.read( movieInfoProvider.notifier ).loadMovie(widget.movieId);
    ref.read( actorsByMovieProvider.notifier ).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];

    if( movie == null ) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2.0,),)
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [

          CustomSliverAppBar( movie: movie, ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            )
          ),

        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  const _MovieDetails({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10,),

              // Description
              SizedBox(
                width: (size.width * 0.7) - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyles.titleLarge,),
                    Text(movie.overview,),
                  ],
                ),
              ),

            ],
          ),
        ),

        // Movie genres
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genre) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(genre),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),
        
        const SizedBox(height: 50,),
      ],
    );
  }
}


class _ActorsByMovie extends ConsumerWidget {

  const _ActorsByMovie({required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final actors = ref.watch( actorsByMovieProvider )[movieId];

    if( actors == null ) {
      return const CircularProgressIndicator(strokeWidth: 2.0,);
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: actors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {

          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Actor photo
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Name
                const SizedBox(height: 5,),

                Text(actor.name, maxLines: 2,),
                Text(
                  actor.character ?? '', 
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: true,
        // titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  
                  if( loadingProgress != null ) return const SizedBox();

                  return FadeIn(child: child);

                },
              ),
            ),

            const _Gradient(stops: [0.7, 1.0],),

            const _Gradient(
              colors: [
                Colors.black45,
                Colors.transparent
              ],
              stops: [0, 0.2],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),

          ],
        ),
      ),
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient({
    this.stops,
    this.colors = const [
      Colors.transparent,
      Colors.black87,
    ],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter
  });

  final List<double>? stops;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            stops: stops,
            begin: begin,
            end: end,
          ),
        ),
      ),
    );
  }
}