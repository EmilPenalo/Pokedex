import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import 'package:pokedex/pages/paged_list.dart';

import 'ui/HomePageHeader/header_actions.dart';
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
      home: BigAppBar()
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
        // PokemonList(scrollController: _scrollController)
      ],
      physics: const BouncingScrollPhysics(),
      scrollController: _scrollController,
      backgroundColor: Colors.grey[50],
      appBarColor: primaryColor()
    );
  }

}

class BigAppBar extends StatelessWidget {
  const BigAppBar({super.key});

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
                // floating: false,
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





