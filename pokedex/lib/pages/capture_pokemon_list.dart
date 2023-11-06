import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list.dart';
import 'package:pokedex/ui/HomePageHeader/header_actions.dart';
import '../style_variables.dart';
class CapturePokemonList extends StatefulWidget {
  const CapturePokemonList({super.key});

  @override
  State<CapturePokemonList> createState() => _CapturePokemonListState();
}

class _CapturePokemonListState extends State<CapturePokemonList> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captured Pokemons'),
          centerTitle: true,
          backgroundColor: primaryColor(),
          elevation: 0,
        ),
        body: Column(
          children: [
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
              child: searchBar(updateSearchQuery)
            ),
            const SizedBox(height: 10),

            Flexible(
              fit: FlexFit.loose,
              child: PokemonList(captured: true, searchTerm: searchQuery)
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
}
