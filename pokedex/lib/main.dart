import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list.dart';

import 'assets/HomePageHeader/favorites_action_button.dart';
import 'assets/HomePageHeader/header_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'POKEDEX',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: const Text("POKEDEX"),
      actions: [
        favoritesActionButton()
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: const [

        Text("Search Bar"),

        Text("Filter Assets"),

        // Listado principal
        PokemonList()

      ],
      backgroundColor: Colors.grey[50],
      appBarColor: Colors.blue,
    );
  }

}




