import 'package:flutter/material.dart';

import '../assets/PokemonList/card_item_bg.dart';
import '../assets/PokemonList/card_item_number.dart';
import '../assets/PokemonList/liked_icon.dart';

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
            crossAxisCount: 2,
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

                        if (true) // Conditional si esta liked
                          likedIcon(),

                        cardItemNumber("#001"),

                        cardItemBackground()
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


