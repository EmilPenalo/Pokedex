import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/helpers/database_helper.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon/pokemon_more_info.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/species/pokemon_species_info.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../helpers/image_helper.dart';
import '../helpers/text_helper.dart';
import '../models/moves/pokemon_moves.dart';
import '../models/moves/pokemons_move_info.dart';
import '../style_variables.dart';
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

Future<PokemonSpeciesInfo> fetchPokemonSpeciesInfo(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return PokemonSpeciesInfo.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load PokemonSpeciesInfo');
  }
}

Future<List<PokemonMoveInfo>> fetchPokemonMoveInfo(List<Moves> moves) async {
  List<PokemonMoveInfo> results = [];

  for (Moves move in moves) {
    String url = move.move.url;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      results.add(PokemonMoveInfo.fromJson(responseData as Map<String, dynamic>));
    } else {
      throw Exception('Failed to load PokemonMoveInfo');
    }
  }

  return results;
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
  final _controller = PageController();
  late Future<PokemonMoreInfo> _futurePokemonMoreInfo;
  late Pokemon pokemon = widget.pokemon;
  int totalPokemonCount = DatabaseHelper.totalPokemonCount;

  @override
  void initState() {
    _futurePokemonMoreInfo = fetchPokemonMoreInfo(pokemon.url);
    super.initState();
  }

  void loadPreviousPokemon() async {
    if (pokemon.id > 1) {
      final previousPokemon = await DatabaseHelper.getPokemonById(pokemon.id - 1);
      if (previousPokemon != null) {
        setState(() {
          pokemon = previousPokemon;
          _futurePokemonMoreInfo = fetchPokemonMoreInfo(pokemon.url);
        });
      }
    }
  }

  void loadNextPokemon() async {
    if (pokemon.id < totalPokemonCount) {
      final nextPokemon = await DatabaseHelper.getPokemonById(pokemon.id + 1);
      if (nextPokemon != null) {
        setState(() {
          pokemon = nextPokemon;
          _futurePokemonMoreInfo = fetchPokemonMoreInfo(pokemon.url);
        });
      }
    }
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

          return FutureBuilder<PokemonSpeciesInfo>(
            future: fetchPokemonSpeciesInfo(pokemonMoreInfo.species.url),
            builder: (context, pokemonSpeciesInfoSnapshot) {
              if(pokemonSpeciesInfoSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${pokemonSpeciesInfoSnapshot.error}')
                );
              } else if (!pokemonSpeciesInfoSnapshot.hasData) {
                return const LoadingScreen(totalPokemonCount: 0, loadingProgress: 0);

              } else {
                final pokemonSpeciesInfo = pokemonSpeciesInfoSnapshot.data;

                return FutureBuilder<List<PokemonMoveInfo>>(
                  future: fetchPokemonMoveInfo(pokemonMoreInfo.moves),
                  builder: (context, pokemonMovesInfoSnapshot) {
                    if(pokemonMovesInfoSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${pokemonMovesInfoSnapshot.error}')
                      );
                    } else if (!pokemonMovesInfoSnapshot.hasData) {
                      return const LoadingScreen(totalPokemonCount: 0, loadingProgress: 0);

                    } else {
                      final pokemonMovesInfo = pokemonMovesInfoSnapshot.data;

                      return Scaffold(

                        // Appbar transparente
                        extendBodyBehindAppBar: true,
                        appBar: detailsAppBar(
                            name: pokemon.name,
                            id: pokemon.id
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
                              height: 90,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20))
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    100, 40, 100, 5),
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
                                child: pokemonImage(
                                    pokemonMoreInfo.sprites.other
                                        .officialArtwork
                                        .frontDefault),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 20,
                              margin: const EdgeInsets.fromLTRB(
                                  10, 350, 10, 10),
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: _controller,
                                  count: 3,
                                  effect: const ExpandingDotsEffect(
                                      activeDotColor: Colors.white,
                                      dotColor: Colors.white54,
                                      dotWidth: 50
                                  ),
                                ),
                              ),
                            ),

                            // Información
                            PageView(
                              controller: _controller,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      8, 380, 8, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)
                                      )
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                            children: [

                                              // About Header
                                              detailHeaderConstructor(
                                                  title: 'About',
                                                  type: pokemonMoreInfo.types[0]
                                                      .type.name,
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 0, 20, 20)
                                              ),

                                              // Informacion general
                                              aboutInfo(
                                                  weight: pokemonMoreInfo.weight
                                                      .toString(),
                                                  height: pokemonMoreInfo.height
                                                      .toString()
                                              ),

                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(20, 20, 20, 10),
                                                child: Text(
                                                  pokemonSpeciesInfo!
                                                      .firstEnglishFlavorText!
                                                      .flavorText,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey[700]
                                                  ),
                                                ),
                                              ),

                                              // Abilities Header
                                              detailHeaderConstructor(
                                                  title: 'Abilities',
                                                  type: pokemonMoreInfo.types[0]
                                                      .type.name
                                              ),

                                              // Abilities
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    8, 0, 8, 0),
                                                child: Column(
                                                  children: pokemonMoreInfo
                                                      .abilities
                                                      .map((ability) {
                                                    if (ability.isHidden) {
                                                      return pokemonHiddenAbility(
                                                        ability: capitalizeFirstLetter(
                                                            ability.ability
                                                                .name),
                                                        typeColor: primaryTypeColor,
                                                      );
                                                    } else {
                                                      return pokemonAbility(
                                                        ability: capitalizeFirstLetter(
                                                            ability.ability
                                                                .name),
                                                        typeColor: primaryTypeColor,
                                                      );
                                                    }
                                                  }).toList(),
                                                ),
                                              ),

                                              // Stats Header
                                              detailHeaderConstructor(
                                                  title: 'Base Stats',
                                                  type: pokemonMoreInfo.types[0]
                                                      .type.name,
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 20, 20, 0)
                                              ),

                                              // Grafico de stats
                                              StatsGraph(
                                                statsMap: statsMap,
                                                typeColor: primaryTypeColor,
                                              ),

                                              detailHeaderConstructor(
                                                  title: 'Breeding',
                                                  type: pokemonMoreInfo.types[0]
                                                      .type.name,
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 0, 20, 20)
                                              ),

                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(10, 0, 10, 10),
                                                child: Row(
                                                  children: [
                                                    for (var eggGroup in pokemonSpeciesInfo
                                                        .eggGroups)
                                                      Expanded(
                                                        child: Container(
                                                          margin: const EdgeInsets
                                                              .all(5),
                                                          padding: const EdgeInsets
                                                              .all(10),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                            border: Border.all(
                                                              color: primaryTypeColor,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          width: double
                                                              .infinity,
                                                          child: Text(
                                                            capitalizeFirstLetter(
                                                                eggGroup.name),
                                                            style: softerTextStyle(),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      8, 380, 8, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)
                                      )
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        detailHeaderConstructor(
                                            title: 'Moves',
                                            type: pokemonMoreInfo.types[0].type
                                                .name,
                                            padding: const EdgeInsets.all(20)
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
                                          child: Column(
                                            children: pokemonMovesInfo
                                                !.map((move) {
                                              return Row(
                                                children: [
                                                  Text(move.name),
                                                  Text(move.type.name),
                                                  Text(move.damageClass.name),
                                                  Text(move.power.toString()),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      8, 380, 8, 0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)
                                      )
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          detailHeaderConstructor(
                                              title: 'Evolutions',
                                              type: pokemonMoreInfo.types[0]
                                                  .type.name,
                                              padding: const EdgeInsets.all(20)
                                          ),
                                          Center(
                                            child: Text("Coming soon...",
                                                style: baseTextStyle()),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Navegación entre pokemones
                            Container(
                              margin: const EdgeInsets.fromLTRB(8, 150, 8, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_before_rounded,
                                      size: 35,
                                    ),
                                    color: Colors.white,
                                    disabledColor: Colors.transparent,
                                    onPressed: (pokemon.id > 1)
                                        ? loadPreviousPokemon
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_next_rounded,
                                      size: 35,
                                    ),
                                    color: Colors.white,
                                    disabledColor: Colors.transparent,
                                    onPressed: (pokemon.id < totalPokemonCount)
                                        ? loadNextPokemon
                                        : null,
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                  }
                );
              }
            }
          );
        }
      },
    );
  }
}
