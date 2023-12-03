import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/helpers/text_helper.dart';
import 'package:pokedex/models/moves/pokemons_move_info.dart';
import 'package:http/http.dart' as http;

import '../../models/moves/pokemon_moves_effect_entries.dart';
import '../../style_variables.dart';
import '../Pokemon/pokemon_types.dart';

Future<MoveEffectEntries> fetchMoveEffectEntries(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return MoveEffectEntries.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load moveEffectEntries');
  }
}

class MoveDetailsSheet extends StatefulWidget {
  final String name;
  final PokemonMoveInfo item;
  final Color color;

  const MoveDetailsSheet({super.key, required this.name, required this.item, required this.color});

  @override
  State<MoveDetailsSheet> createState() => _MoveDetailsSheetState();
}

class _MoveDetailsSheetState extends State<MoveDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MoveEffectEntries>(
      future: fetchMoveEffectEntries(widget.item.contestEffect),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();

        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');

        } else {
          final moveEffectEntries = snapshot.data;

          String addPossessiveSuffix(String name) {
            if (name.endsWith('s')) {
              return "$name'";
            } else {
              return "$name's";
            }
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        capitalizeFirstLetter(widget.item.name),
                        style: headingTextStyleButColorType(Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${capitalizeFirstLetter(addPossessiveSuffix(widget.name))} move",
                          style: baseTextStyleButColorType(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 20, 10, 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: getPokemonTypeColor(capitalizeFirstLetter(widget.item.damageClass.name)),
                                  width: 1,
                                ),
                              ),
                              width: double.infinity,
                              child: Text(
                                capitalizeFirstLetter(widget.item.damageClass.name),
                                style: baseTextStyleButColorType(getPokemonTypeColor(capitalizeFirstLetter(widget.item.damageClass.name))),
                              ),
                            )
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(10, 20, 20, 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.item.type.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Type',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Category',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.power?.toString() ?? "-",
                                textAlign: TextAlign.center,
                                style: softerTextStyle()
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.item.accuracy?.toString() ?? "-",
                                textAlign: TextAlign.center,
                                style: softerTextStyle()
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.item.pp.toString(),
                                textAlign: TextAlign.center,
                                style: softerTextStyle()
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Power',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Accuracy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'PP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Effect",
                                          style: baseTextStyleButColorType(widget.color)
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          moveEffectEntries?.effect ?? 'None',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey[700]
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}