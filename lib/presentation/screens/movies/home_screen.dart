
import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

import '../../views/views.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  final viewRoutes = const <Widget> [
    HomeView(),
    CategoriesView(),
    FavoritesView(),
  ];

  static const name = "home-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // * NOTE: IndexedStack preserves the state
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes
      ),
      bottomNavigationBar: CustomBottomNavigation( currentIndex: pageIndex, ),
    );
  }
}