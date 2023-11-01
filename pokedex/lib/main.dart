import 'package:flutter/material.dart';

import 'package:pokedex/pages/pokemon_list.dart';

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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context),
              sliver: SliverAppBar(
                backgroundColor: primaryColor(),
                expandedHeight: 300,
                collapsedHeight: 105,
                pinned: true,
                flexibleSpace: headerWidget(context),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.only(top: 130),
          color: primaryColor(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(top: 10),
            child: const PokemonList(),
          ),
        )
      ),
    );

  }
}





