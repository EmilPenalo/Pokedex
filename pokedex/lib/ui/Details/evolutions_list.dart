import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/helpers/database_helper.dart';
import 'package:pokedex/models/evolutions/pokemon_evolutions_info.dart';
import 'package:pokedex/models/species/pokemon_species.dart';
import '../../helpers/image_helper.dart';
import '../../helpers/text_helper.dart';
import '../../models/evolutions/pokemon_evolutions_chain.dart';
import '../../models/pokemon/pokemon_info.dart';
import '../../style_variables.dart';
import '../Pokemon/pokemon_types.dart';

class EvolutionsList extends StatefulWidget {
  final String url;
  final Function loadPokemon;

  const EvolutionsList({super.key, required this.url, required this.loadPokemon});

  @override
  State<EvolutionsList> createState() => _EvolutionsListState();
}

class _EvolutionsListState extends State<EvolutionsList> {
  Future<PokemonInfo> fetchPokemonInfo(String url) {
    final updatedUrl = url.replaceFirst("pokemon-species", "pokemon");

    return http.get(Uri.parse(updatedUrl))
        .then((response) {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PokemonInfo.fromJson(responseData as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load pokemonInfo: $url');
      }
    });
  }

  Future<PokemonEvolutionsInfo> fetchPokemonEvolutionsInfo() async {
    var bytes1 = utf8.encode(widget.url);
    var digest1 = sha256.convert(bytes1);

    if (digest1 != urlHash) {
      urlHash = digest1;

      final response = await http
          .get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PokemonEvolutionsInfo.fromJson(responseData as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load pokemonEvolutionsInfo');
      }
    } else {
      return evolutionResult;
    }
  }

  int previousLevel = -1;
  Digest? urlHash;

  PokemonEvolutionsInfo evolutionResult = PokemonEvolutionsInfo(chain: Chain(
    evolvesTo: [],
    species: const Species(
      name: "Not found",
      url: "",
    )
  ));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonEvolutionsInfo>(
      future: fetchPokemonEvolutionsInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final pokemonEvolutionsInfo = snapshot.data;
          evolutionResult = pokemonEvolutionsInfo!;
          return buildEvolutionTree(pokemonEvolutionsInfo.chain, 0);
        }
      },
    );
  }

  Widget buildEvolutionTree(Chain chain, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<PokemonInfo>(
          future: fetchPokemonInfo(chain.species.url),
          builder: (context, pokemonInfoSnapshot) {
            if (pokemonInfoSnapshot.hasError) {
              return Text('Error: ${pokemonInfoSnapshot.error}');
            } else if (!pokemonInfoSnapshot.hasData) {
              return const SizedBox(height: 20);
            } else {
              final pokemonInfo = pokemonInfoSnapshot.data;

              Color primaryTypeColor =
              getPokemonTypeColor(capitalizeFirstLetter(pokemonInfo!.types[0].type.name));

              bool showIcon = chain.evolvesTo.isNotEmpty && level != previousLevel;
              previousLevel = level;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        widget.loadPokemon(await DatabaseHelper.getPokemonIdByName(chain.species.name));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryTypeColor.withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                  capitalizeFirstLetter(chain.species.name),
                                  textAlign: TextAlign.center,
                                  style: softerTextStyle()
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: pokemonImage(
                                  pokemonInfo.sprites.other.officialArtwork
                                      .frontDefault),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(75, 10, 75, 10),
                              child: pokemonTypes(
                                capitalizeFirstLetter(
                                    pokemonInfo.types[0].type.name),
                                pokemonInfo.types.length >= 2
                                    ? capitalizeFirstLetter(
                                    pokemonInfo.types[1].type.name)
                                    : '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (showIcon)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 2,
                                color: Colors.grey[100],
                                margin: const EdgeInsets.fromLTRB(0, 8, 5, 12),
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey[400],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 2,
                                color: Colors.grey[100],
                                margin: const EdgeInsets.fromLTRB(5, 8, 0, 12),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              );
            }
          },
        ),
        if (chain.evolvesTo.isNotEmpty)
          Column(
            children: [
              for (var nextChain in chain.evolvesTo) buildEvolutionTree(nextChain, level + 1),
            ],
          ),
      ],
    );
  }
}