import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_more_info.dart';
import 'package:http/http.dart' as http;

import '../helpers/image_helper.dart';
import '../helpers/text_helper.dart';
import '../ui/Details/detail_widgets.dart';
import '../ui/Details/stats_graph.dart';
import '../ui/Pokemon/pokemon_types.dart';
import 'package:pokedex/pages/loading_screen.dart';

Future<PokemonMoreInfo> fetchPokemonMoreInfo(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return PokemonMoreInfo.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load pokemonMoreInfo');
  }
}

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetails({
    super.key,
    required this.pokemon
  });

  @override
  State<PokemonDetails> createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonDetails> {
  late Future<PokemonMoreInfo> _futurePokemonMoreInfo;

  @override
  void initState() {
    _futurePokemonMoreInfo = fetchPokemonMoreInfo(widget.pokemon.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonMoreInfo>(
      future: _futurePokemonMoreInfo,
      builder: (context, pokemonMoreInfoSnapshot) {
        if(pokemonMoreInfoSnapshot.hasError) {
          return Center(
              child: Text('Error: ${pokemonMoreInfoSnapshot.error}')
          );

        } else if (!pokemonMoreInfoSnapshot.hasData) {
          return const LoadingScreen(totalPokemonCount: 0, loadingProgress: 0);

        } else { // snapshot.hasData
          final pokemonMoreInfo = pokemonMoreInfoSnapshot.data;

          // Mapa de stats del pokemon
          Map<String, double> statsMap = {};
          for (var stat in pokemonMoreInfo!.stats) {
            String statName = stat.stat.name;
            double baseStat = stat.baseStat.toDouble();
            statsMap[statName] = baseStat;
          }

          // Definiendo los colores a utilizar segun los tipos del pokemon
          Color primaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));
          Color secondaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));

          if (pokemonMoreInfo.types.length > 1) {
            secondaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[1].type.name));
          }

          return Scaffold(

            // Appbar transparente
            extendBodyBehindAppBar: true,
            appBar: detailsAppBar(
                name: widget.pokemon.name,
                id: widget.pokemon.id
            ),
            body: Stack(
              children: [

                // Fondo decorativo
                typeGradient(primaryTypeColor, secondaryTypeColor),

                // Imagen decoractiva de pokebola
                pokeballDecoration(context),

                // Tipos del pokemon
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 250, 8, 0),
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                        100, 40, 100, 10),
                    child: pokemonTypes(
                      capitalizeFirstLetter(
                          pokemonMoreInfo.types[0].type.name),
                      pokemonMoreInfo.types.length >= 2
                          ? capitalizeFirstLetter(
                          pokemonMoreInfo.types[1].type.name)
                          : '',
                    ),
                  ),
                ),

                // Imagen del pokemon
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: SizedBox(
                    height: 225,
                    child: pokemonImage(pokemonMoreInfo.sprites.other.officialArtwork.frontDefault),
                  ),
                ),

                // Informacion del pokemon
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 335, 8, 0),
                  color: Colors.white,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          // About Header
                          detailHeaderConstructor(
                            title: 'About',
                            type: pokemonMoreInfo.types[0].type.name,
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20)
                          ),

                          // Informacion general
                          aboutInfo(
                              weight: pokemonMoreInfo.weight.toString(),
                              height: pokemonMoreInfo.height.toString()
                          ),

                          // Abilities Header
                          detailHeaderConstructor(
                              title: 'Abilities',
                              type: pokemonMoreInfo.types[0].type.name
                          ),

                          // Abilities
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              children: pokemonMoreInfo.abilities.map((ability) {
                                if (ability.isHidden) {

                                  return pokemonHiddenAbility(
                                    ability: capitalizeFirstLetter(ability.ability.name),
                                    typeColor: primaryTypeColor,
                                  );

                                } else {

                                  return pokemonAbility(
                                    ability: capitalizeFirstLetter(ability.ability.name),
                                    typeColor: primaryTypeColor,
                                  );

                                }
                              }).toList(),
                            ),
                          ),

                          // Stats Header
                          detailHeaderConstructor(
                              title: 'Base Stats',
                              type: pokemonMoreInfo.types[0].type.name,
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0)
                          ),

                          // Grafico de stats
                          StatsGraph(
                            statsMap: statsMap,
                            typeColor: primaryTypeColor,
                          )

                        ]
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        }
      },
    );
  }
}
