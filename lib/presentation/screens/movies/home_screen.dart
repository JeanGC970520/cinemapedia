
import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

import '../../views/views.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const name = "home-screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}