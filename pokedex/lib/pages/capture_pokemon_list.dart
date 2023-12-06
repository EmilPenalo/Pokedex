import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list.dart';
import 'package:pokedex/ui/HomePage/header_actions.dart';
import '../style_variables.dart';
import '../ui/HomePage/filter_widgets.dart';
class CapturePokemonList extends StatefulWidget {
  const CapturePokemonList({super.key});

  @override
  State<CapturePokemonList> createState() => _CapturePokemonListState();
}

class _CapturePokemonListState extends State<CapturePokemonList> {
  String searchQuery = "";
  String typeFilter = "";
  int genFilter = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captured Pokemons'),
          centerTitle: true,
          backgroundColor: primaryColor(),
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: primaryColor(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500]!,
                    blurRadius: 8,
                  )
                ]
              ),
              child: searchBar(updateSearchQuery, searchController)
            ),
            // const SizedBox(height: 10),

            Container(
              color: primaryColor(),
              margin: const EdgeInsets.only(top: 50),
              child: FilterButtons(
                genUpdate: updateGenFilter,
                typeUpdate: updateTypeFilter,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 90),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 7,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 10),
              child: PokemonList(captured: true, searchTerm: searchQuery, gen: genFilter, type: typeFilter),
            )
          ],
        )
    );
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }
  void updateGenFilter(int gen) {
    setState(() {
      genFilter = gen;
    });
  }
  void updateTypeFilter(String type) {
    setState(() {
      typeFilter = type;
    });
  }
}
