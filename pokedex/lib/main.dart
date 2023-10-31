import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import 'package:pokedex/pages/custom_inf_scroll.dart';

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
    return MaterialApp(
      title: 'POKEDEX',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return DraggableHome(
      title: appHeaderTitle(),
      actions: [
        favoritesActionButton(context)
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(context),
      body: [
        PokemonList(scrollController: _scrollController)
      ],
      physics: const BouncingScrollPhysics(),
      scrollController: _scrollController,
      backgroundColor: Colors.grey[50],
      appBarColor: primaryColor()
    );
  }

}




