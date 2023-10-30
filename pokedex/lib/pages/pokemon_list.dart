import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_info.dart';

import '../helpers/text_helper.dart';
import '../models/pokedex.dart';
import '../ui/Pokemon/card_item_widgets.dart';
import '../helpers/image_helper.dart';
import '../ui/Pokemon/pokemon_types.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'card_item.dart';

Future<Pokedex> fetchPokedex(String? url) async {
  final response = await http
      .get(Uri.parse(url!));

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

  static const _pageSize = 20;
  final PagingController<int, Pokemon> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
    _futurePokedex = fetchPokedex('https://pokeapi.co/api/v2/pokemon');
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final pokedex = await fetchPokedex('https://pokeapi.co/api/v2/pokemon?limit=20&offset=$pageKey*20');
      final newItems = pokedex.results;

      final isLastPage = pokedex.count < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokedex>(
        future: _futurePokedex,
        builder: (context, pokedexSnapshot) {
          if (pokedexSnapshot.hasError) {
            return Text('Error: ${pokedexSnapshot.error}');

          } else if (!pokedexSnapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: const CircularProgressIndicator()
            );

          } else { // snapshot.hasData
            final pokedex = pokedexSnapshot.data;

            GridView builder = GridView.builder(
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
                if (pokemon == null) {
                  return pokemonCardError();
                }
                return PokemonCard(pokemon: pokemon, index: index);
              },
            );

            return builder;
          }
        },
    );
  }
}