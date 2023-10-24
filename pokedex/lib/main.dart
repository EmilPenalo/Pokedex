import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list.dart';

import 'ui/HomePageHeader/favorites_action_button.dart';
import 'ui/HomePageHeader/header_widgets.dart';
import 'style_variables.dart';

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
      title: appHeaderTitle(),
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
      appBarColor: primaryColor()
    );
  }

}




