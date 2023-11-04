import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_more_info.dart';
import 'package:http/http.dart' as http;

import '../helpers/image_helper.dart';
import '../helpers/text_helper.dart';
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

  TextStyle headingTextStyle(String type) {
    return TextStyle(
      color: getPokemonTypeColor(capitalizeFirstLetter(type)),
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonMoreInfo>(
      future: _futurePokemonMoreInfo,
      builder: (context, pokemonMoreInfoSnapshot) {
        if(pokemonMoreInfoSnapshot.hasError) {
          return Text('Error: ${pokemonMoreInfoSnapshot.error}');
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

          Color primaryColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));
          Color secondaryColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name));

          if (pokemonMoreInfo.types.length > 1) {
            secondaryColor = getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[1].type.name));
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: const Color(0x44000000),
              elevation: 0,
              title: Text(capitalizeFirstLetter(widget.pokemon.name),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
              ),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        formatNumber(widget.pokemon.id),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Stack(
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 300, 10, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                            child: Text('About',
                              style: headingTextStyle(pokemonMoreInfo.types[0].type.name)
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                                        children: [
                                          SvgPicture.asset(
                                            'lib/resources/weight.svg',
                                            width: 20,
                                            height: 20,
                                            colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
                                          ),
                                          Text(' ${pokemonMoreInfo.weight.toString()} kg',
                                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                          ) // Text
                                        ],
                                      ),
                                      Container(padding: const EdgeInsets.all(10), child: Text('Weight',
                                        style: TextStyle(color: Colors.grey[400]),
                                      ))
                                    ],
                                  )
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 70,
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                                        children: [
                                          SvgPicture.asset(
                                            'lib/resources/ruler.svg',
                                            width: 20,
                                            height: 20,
                                            colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
                                          ),
                                          Text(' ${pokemonMoreInfo.height.toString()} m',
                                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                          ) // Text
                                        ],
                                      ),
                                      Container(padding: const EdgeInsets.all(10), child: Text('Height',
                                        style: TextStyle(color: Colors.grey[400]),
                                      ))
                                    ],
                                  )
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text('Abilities',
                                style: headingTextStyle(pokemonMoreInfo.types[0].type.name)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: pokemonMoreInfo.abilities.map((ability) {
                                if (ability.isHidden) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name)),
                                        width: 1,
                                      ),
                                    ),
                                    width: double.infinity,
                                    child: Text(
                                      capitalizeFirstLetter(ability.ability.name),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name)),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            capitalizeFirstLetter(ability.ability.name),
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: getPokemonTypeColor(capitalizeFirstLetter(pokemonMoreInfo.types[0].type.name)),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            "Hidden",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }).toList(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text('Base Stats',
                                style: headingTextStyle(pokemonMoreInfo.types[0].type.name)
                            ),
                          ),
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
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 250, 10, 0),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: SizedBox(
                    height: 200,
                    child: pokemonImage(pokemonMoreInfo.sprites.other.officialArtwork.frontDefault),
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
