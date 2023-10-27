import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_info.dart';

import '../models/pokedex.dart';
import '../ui/Pokemon/card_item_widgets.dart';
import '../ui/Pokemon/image_helper.dart';
import '../ui/Pokemon/pokemon_types.dart';
import 'package:http/http.dart' as http;

Future<Pokedex> fetchPokedex() async {
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return Pokedex.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load pokedex');
  }
}

Future<PokemonInfo> fetchPokemonInfo(String url) async {
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return PokemonInfo.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load pokemonInfo');
  }
}

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<Pokedex> _futurePokedex;

  @override
  void initState() {
    super.initState();
    _futurePokedex = fetchPokedex();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokedex>(
        future: _futurePokedex,
        builder: (context, pokedexSnapshot) {
          if (pokedexSnapshot.hasError) {
            return Text('Error: ${pokedexSnapshot.error}');

          } else if (!pokedexSnapshot.hasData) {
            return const CircularProgressIndicator();

          } else { // snapshot.hasData
            final pokedex = pokedexSnapshot.data;
            return GridView.builder(
              /* IMPORTANT */
              // Previenen error de rendering con el header de la pagina principal
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              //itemCount: 20,  // Cambiar al numero de pokemons
              itemCount: pokedex?.results.length ?? 0,
              /* IMPORTANT */

              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Pokemons por fila
              ),
              itemBuilder: (BuildContext context, int index) {
                final pokemon = pokedex?.results[index];
                return FutureBuilder<PokemonInfo>(
                  future: fetchPokemonInfo(pokemon?.url ?? "URL"),
                  builder: (context, pokemonInfoSnapshot) {
                    if (pokemonInfoSnapshot.hasError) {
                      return Text('Error: ${pokemonInfoSnapshot.error}');

                    } else if (!pokemonInfoSnapshot.hasData) {
                      return const CircularProgressIndicator();

                    } else { // snapshot.hasData
                      final pokemonInfo = pokemonInfoSnapshot.data;
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Card(
                              color: Colors.white,
                              elevation: 0.8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Stack(
                                children: [

                                  // Icono de favorito
                                  if (true) // Conditional si esta liked
                                    likedIcon(),

                                  // Numero del Pokemon
                                  cardItemNumber(pokemonInfo?.id.toString() ?? "ID"),

                                  // Fondo decorativo
                                  cardItemBackground(),

                                  // Informacion del Pokemon
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [

                                        // Imagen del pokemon
                                        pokemonImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"),

                                        // Nombre del pokemon
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                          child: pokemonNameWidget(pokemon?.name ?? "NAME"),
                                        ),

                                        // Tipos del pokemon
                                        Container(
                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                            child: pokemonTypes(
                                              pokemonInfo?.types[0].type.name ?? "TYPE 1",
                                              pokemonInfo?.types[1].type.name ?? "TYPE 2",
                                            )
                                        ),

                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            );
          }
        },
    );
  }
}
