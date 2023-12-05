import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/helpers/text_helper.dart';
import 'package:pokedex/models/pokemon/pokemon_ability_info.dart';
import 'package:http/http.dart' as http;

import '../../style_variables.dart';
import 'detail_widgets.dart';

Future<PokemonAbilityInfo> fetchPokemonAbilityInfo(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return PokemonAbilityInfo.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load pokemonAbilityInfo');
  }
}

class AbilityDetailsSheet extends StatefulWidget {
  final String name;
  final String url;
  final String ability;
  final Color typeColor;

  const AbilityDetailsSheet({super.key, required this.name, required this.url, required this.ability, required this.typeColor});

  @override
  State<AbilityDetailsSheet> createState() => _AbilityDetailsSheetState();
}

class _AbilityDetailsSheetState extends State<AbilityDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonAbilityInfo>(
      future: fetchPokemonAbilityInfo(widget.url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return evolutionSheetPlaceholder(color: widget.typeColor);

        } else if (snapshot.hasError) {
          return Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              alignment: Alignment.center,
            child: Text('Error: ${snapshot.error}')
          );

        } else {
          final pokemonAbilityInfo = snapshot.data;

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
                      color: widget.typeColor,
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
                        widget.ability,
                        style: headingTextStyleButColorType(Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${capitalizeFirstLetter(addPossessiveSuffix(widget.name))} ability",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                                    style: baseTextStyleButColorType(widget.typeColor)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    pokemonAbilityInfo?.firstEnglishEffect?.shortEffect ?? 'None',
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                    "In-Depth Effect",
                                    style: baseTextStyleButColorType(widget.typeColor)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    pokemonAbilityInfo?.firstEnglishEffect?.effect ?? 'None',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[700]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          );
        }
      },
    );
  }
}