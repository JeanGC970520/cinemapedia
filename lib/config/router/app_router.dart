
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart'; 

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [

    GoRoute(
      path: '/home/:page', //Add an argument to recive the tap selected on the bottom nav bar.
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';
        return HomeScreen( pageIndex: int.parse(pageIndex), );
      },
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

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    ),

  ]
);