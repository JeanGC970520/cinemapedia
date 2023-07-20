
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart'; 

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      // * NOTES: 
      // *  - routes are the children routes of a route. 
      // *  - This is useful with deeplinking implementation.
      routes: [
        // Passing parameters to the rute
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            // Fetching the parameter of the route to used it
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: movieId,);
          },
        ),
      ]
    ),

  ]
);