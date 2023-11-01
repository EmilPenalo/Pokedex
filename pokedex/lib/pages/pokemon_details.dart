import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_more_info.dart';
import 'package:http/http.dart' as http;

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
  final String url;

  const PokemonDetails({
    super.key,
    required this.url
  });

  @override
  State<PokemonDetails> createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonDetails> {
  late Future<PokemonMoreInfo> _futurePokemonMoreInfo;

  @override
  void initState() {
    _futurePokemonMoreInfo = fetchPokemonMoreInfo(widget.url);
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
              title: const Text('DETALLES!'),
            ),
            body: Column(
              children: [
                Text('Height: ${pokemonMoreInfo?.height.toString()}'),
                Text('Weight: ${pokemonMoreInfo?.weight.toString()}'),
                Text('Abilities:'),
                Column(
                  children: pokemonMoreInfo!.abilities
                      .map((ability) => Text(ability.ability.name))
                      .toList(),
                ),
                Text('Stats:'),
                Column(
                  children: pokemonMoreInfo.stats
                      .map((stat) => Text(stat.stat.name))
                      .toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
