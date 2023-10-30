import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:http/http.dart' as http;
import '../helpers/text_helper.dart';
import '../models/pokemon_info.dart';
import '../ui/Pokemon/card_item_widgets.dart';
import '../helpers/image_helper.dart';
import '../ui/Pokemon/pokemon_types.dart';

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

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final int index;

  const PokemonCard({
    required this.pokemon,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonInfo>(
        future: fetchPokemonInfo(pokemon.url),
        builder: (context, pokemonInfoSnapshot) {
          if (pokemonInfoSnapshot.hasError) {
            return Text('Error: ${pokemonInfoSnapshot.error}');
          } else if (!pokemonInfoSnapshot.hasData) {
            return pokemonCardPlaceHolder();
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
                        cardItemNumber(
                          formatNumber(pokemonInfo!.id),
                        ),
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
                              SizedBox(
                                height: 115, // Tamaño maximo de la foto
                                child: pokemonImage(
                                    pokemonInfo.sprites.other.officialArtwork
                                        .frontDefault),
                              ),

                              // Nombre del pokemon
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 0, 12, 8),
                                child: pokemonNameWidget(
                                    capitalizeFirstLetter(pokemon.name)
                                ),
                              ),

                              // Tipos del pokemon
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 8),
                                child: pokemonTypes(
                                  capitalizeFirstLetter(
                                      pokemonInfo.types[0].type.name),
                                  pokemonInfo.types.length >= 2
                                      ? capitalizeFirstLetter(
                                      pokemonInfo.types[1].type.name)
                                      : '',
                                ),
                              )
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
        });
  }
}
