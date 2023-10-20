import 'package:flutter/material.dart';

import 'package:pokedex/assets/PokemonList/pokemon_types.dart';
import '../assets/PokemonList/card_item_widgets.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
          /* IMPORTANT */
          // Previenen error de rendering con el header de la pagina principal
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,  // Cambiar al numero de pokemons
          /* IMPORTANT */

          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Pokemons por fila
          ),
          itemBuilder: (BuildContext context, int index) {
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
                        cardItemNumber("#001"),

                        // Fondo decorativo
                        cardItemBackground(),

                        // Informacion del Pokemon
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [

                              // Nombre del pokemon
                              Container(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                child: pokemonNameWidget("Bulblasaur"),
                              ),

                              // Tipos del pokemon
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                child: pokemonTypes("Grass", "Poison")
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
          },
    );
  }
}


