import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_more_info.dart';
import 'package:http/http.dart' as http;

import '../helpers/image_helper.dart';
import '../helpers/text_helper.dart';
import '../ui/Details/detail_widgets.dart';
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

          Map<String, double> statsMap = {};
          for (var stat in pokemonMoreInfo!.stats) {
            String statName = stat.stat.name;
            double baseStat = stat.baseStat.toDouble();
            statsMap[statName] = baseStat;
          }

          Color primaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));
          Color secondaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));

          if (pokemonMoreInfo.types.length > 1) {
            secondaryTypeColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[1].type.name));
          }

          return Scaffold(
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
                          Container(
                            height: 300,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: BarChart(
                                BarChartData(
                                  maxY: getMaxStatValue(statsMap),
                                  minY: 0,
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        getTitlesWidget: (value, meta) {
                                          return RotatedBox(
                                            quarterTurns: -1,
                                            child: getBottomTiles(value, meta, statsMap, pokemonMoreInfo.types[0].type.name),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  barGroups: statsMap.entries.map((entry) {
                                    String statName = entry.key;
                                    double baseStat = entry.value;
                                    int statNameXValue = codeStat(statName);
                                    return BarChartGroupData(
                                      x: statNameXValue,
                                      barRods: [
                                        BarChartRodData(
                                          toY: baseStat,
                                          backDrawRodData: BackgroundBarChartRodData(
                                            show: true,
                                            toY: getMaxStatValue(statsMap),
                                            color: Colors.grey[200]
                                          ),
                                          color: getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name))),
                                      ],
                                    );
                                  }).toList()
                                )
                              ),
                            ),
                          ),
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

double getMaxStatValue(Map<String, double> statsMap) {
  double maxValue = statsMap.values.reduce((max, value) => value > max ? value : max);
  if (maxValue < 100) {
    return 100.0;
  }
  return maxValue;
}

int codeStat(String statName) {
  if (statName == "hp") {
    return 0;
  } else if (statName == "attack") {
    return 1;
  } else if (statName == "defense") {
    return 2;
  } else if (statName == "special-attack") {
    return 3;
  } else if (statName == "special-defense") {
    return 4;
  } else if (statName == "speed") {
    return 5;
  }

  return -1;
}

String decodeStat(int index) {
  if (index == 0) {
    return "hp";
  } else if (index == 1) {
    return "attack";
  } else if (index == 2) {
    return "defense";
  } else if (index == 3) {
    return "special-attack";
  } else if (index == 4) {
    return "special-defense";
  } else if (index == 5) {
    return "speed";
  }

  return "Nan";
}

Widget getBottomTiles(double value, TitleMeta meta, Map<String, double> statsMap, String type) {
  final TextStyle labelStyle = TextStyle(
    color: getPokemonTypeColor(capitalizeFirstLetter(type)),
    fontSize: 16.0,
    fontWeight: FontWeight.w800,
  );

  final TextStyle valueStyle = TextStyle(
    color: Colors.grey[600],
    fontSize: 16.0,
  );

  final int index = value.toInt();
  List<String> labelName = ['HP   ', 'ATK   ', 'DEF   ', 'SATK   ', 'SDEF   ', 'SPD   '];
  final String textContent = labelName[index];
  final String statValueText = formatNumberStat(statsMap[decodeStat(index)]!.toInt());

  final List<TextSpan> textSpans = [
    TextSpan(
      text: textContent,
      style: labelStyle,
    ),
    TextSpan(
      text: statValueText,
      style: valueStyle, // Style for the dynamic value
    ),
  ];

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: RichText(
      text: TextSpan(
        children: textSpans,
      ),
    ),
  );
}
