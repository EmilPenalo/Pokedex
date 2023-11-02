import 'dart:convert';

import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pages/pokemon_details.dart';
import '../helpers/text_helper.dart';
import '../models/pokemon_info.dart';
import '../ui/Pokemon/card_item_widgets.dart';
import '../helpers/image_helper.dart';
import '../ui/Pokemon/pokemon_types.dart';

Future<PokemonInfo> fetchPokemonInfo(String url) {
  return http.get(Uri.parse(url))
      .then((response) {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return PokemonInfo.fromJson(responseData as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load pokemonInfo');
    }
  });
}

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard({
    required this.pokemon,
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {

  void onTap(BuildContext context, Pokemon pokemon) {
    Navigator.of(context)
        .push(
        MaterialPageRoute(
            builder: (context) => PokemonDetails(pokemon: pokemon)
        )
    );
  }

  Future<void> onDoubleTap(BuildContext context, Pokemon pokemon) async {
    pokemon.isCaptured = !pokemon.isCaptured;
    await DatabaseHelper.updatePokemon(pokemon);
    setState(() {
      pokemon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, widget.pokemon),
      onDoubleTap: () => onDoubleTap(context, widget.pokemon),

      child: FutureBuilder<PokemonInfo>(
          future: fetchPokemonInfo(widget.pokemon.url),
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
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey[100]!,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        children: [

                          // Icono de capturado
                          if (widget.pokemon.isCaptured)
                            likedIcon(),

                          // Numero del Pokemon
                          cardItemNumber(
                            formatNumber(widget.pokemon.id),
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
                                      pokemonInfo!.sprites.other.officialArtwork
                                          .frontDefault),
                                ),

                                // Nombre del pokemon
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 0, 12, 8),
                                  child: pokemonNameWidget(
                                      capitalizeFirstLetter(widget.pokemon.name)
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
          }),
    );
  }
}
