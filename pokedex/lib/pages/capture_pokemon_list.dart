import 'package:flutter/material.dart';

import '../style_variables.dart';

class CapturePokemonList extends StatelessWidget {
  const CapturePokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Pokemons'),
        centerTitle: true,
        backgroundColor: primaryColor(),
      ),
      body: const Text('99 / 100')
    );
  }
}
