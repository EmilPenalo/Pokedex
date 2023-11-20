import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/evolutions/pokemon_evolutions_info.dart';
import '../../models/evolutions/pokemon_evolutions_chain.dart';

Future<PokemonEvolutionsInfo> fetchPokemonEvolutionsInfo(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return PokemonEvolutionsInfo.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load pokemonEvolutionsInfo');
  }
}

class EvolutionsList extends StatefulWidget {
  final String url;

  const EvolutionsList({super.key, required this.url});

  @override
  State<EvolutionsList> createState() => _EvolutionsListState();
}

class _EvolutionsListState extends State<EvolutionsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonEvolutionsInfo>(
      future: fetchPokemonEvolutionsInfo(widget.url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();

        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');

        } else {
          final pokemonEvolutionsInfo = snapshot.data;
          return buildEvolutionTree(pokemonEvolutionsInfo!.chain, 0);
        }
      },
    );
  }

  Widget buildEvolutionTree(Chain chain, int level) {
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(chain.species.name),
            subtitle: Text(chain.species.url),
          ),
          if (chain.evolvesTo.isNotEmpty)
            Column(
              children: [
                for (var nextChain in chain.evolvesTo)
                  buildEvolutionTree(nextChain, level + 1),
              ],
            ),
        ],
      ),
    );
  }
}

