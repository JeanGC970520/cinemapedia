
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart'; 
import 'package:cinemapedia/presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    // Is useful when we want to navigate changing only a section of the screen
    // Like an app with BottomNavigationBar
    ShellRoute(
      routes: [

        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
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
          ],
        ),

        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const FavoritesView();
          },
        ),

      ],
      builder: (context, state, child) {
        // * NOTE: The child is the Widget that will changed with the 
        // *       navigation of the GoRouter on the BottomNavigationBar
        return HomeScreen(childView: child);
      },
    ),

// ? Routes partener/child
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (context, state) => const HomeScreen(childView: FavoritesView()),
    //   // * NOTES: 
    //   // *  - routes are the children routes of a route. 
    //   // *  - This is useful with deeplinking implementation.
    //   routes: [
    //     // Passing parameters to the rute
    //     GoRoute(
    //       path: 'movie/:id',
    //       name: MovieScreen.name,
    //       builder: (context, state) {
    //         // Fetching the parameter of the route to used it
    //         final movieId = state.pathParameters['id'] ?? 'no-id';
    //         return MovieScreen(movieId: movieId,);
    //       },
    //     ),
    //   ]
    // ),

  ]
);