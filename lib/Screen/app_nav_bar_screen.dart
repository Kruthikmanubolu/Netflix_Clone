import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netflix_clone/Screen/hot_new_screen.dart';
import 'package:netflix_clone/Screen/netflix_home_screen.dart';
import 'package:netflix_clone/Screen/search_screen.dart';
// Add other screen imports when created:
// import 'package:netflix_clone/Screen/games_screen.dart';
// import 'package:netflix_clone/Screen/new_hot_screen.dart';
// import 'package:netflix_clone/Screen/my_netflix_screen.dart';

class AppNavBarScreen extends StatelessWidget {
  const AppNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Iconsax.home5), text: "Home"),
              Tab(icon: Icon(Icons.search), text: "Search"),
              Tab(icon: Icon(Iconsax.like), text: "New & Hot"),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
          ),
        ),
        body: const TabBarView(
          children: [
            NetflixHomeScreen(),
            SearchScreen(),
            HotNewScreen()
          ],
        ),
      ),
    );
  }
}
