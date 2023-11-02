import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_more_info.dart';
import 'package:http/http.dart' as http;

import '../helpers/text_helper.dart';
import '../style_variables.dart';

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
          return Text('Error: ${pokemonMoreInfoSnapshot.error}');
        } else if (!pokemonMoreInfoSnapshot.hasData) {
          return const Text('Loading...');
        } else { // snapshot.hasData
          final pokemonMoreInfo = pokemonMoreInfoSnapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(capitalizeFirstLetter(widget.pokemon.name)),
              actions: [
                Text(formatNumber(widget.pokemon.id)),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text('About',
                      style: headingTextStyle(capitalizeFirstLetter(pokemonMoreInfo!.types[0].type.name)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.fitness_center,
                                color: Colors.grey[800],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text('${pokemonMoreInfo.height.toString()} kg',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text('Weight',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400]
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2,
                        height: 70,
                        color: Colors.grey[200],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.square_foot),
                              Text('${pokemonMoreInfo.weight.toString()} m'),
                            ],
                          ),
                          Text('Height'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}