import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pages/card_item.dart';

import '../models/pokedex.dart';
import 'package:http/http.dart' as http;

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

class PokemonList extends StatefulWidget {
  final ScrollController scrollController;

  const PokemonList({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<Pokemon> items = [];
  int pageKey = 0;
  bool loading = false;

  late Future<Pokedex> _futurePokedex;

  static const _pageSize = 100;

  @override
  void initState() {
    super.initState();
    _fetchPage(true);
  }

  void _fetchPage(bool hardLoad) {
    if (loading) return;

    setState(() {
      loading = true;
    });

    int size;
    if (hardLoad) {
      size = _pageSize;
    } else {
      size = 20;
    }

    if (pageKey >= 0) {
      _futurePokedex = fetchPokedex('https://pokeapi.co/api/v2/pokemon?limit=$size&offset=${items.length}');
      _futurePokedex.then((pokedex) {
        final newItems = pokedex.results;
        final isLastPage = pokedex.count < _pageSize;
        if (isLastPage) {
          setState(() {
            pageKey = -1;
          });
        } else {
          setState(() {
            pageKey = pageKey + 1;
          });
        }
        items.addAll(newItems);
      }).catchError((error) {
        print(error);

      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent) {
        _fetchPage(true);

      } else if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent - (180 * 5)) {
        _fetchPage(false);
      }
    });

    return GridView.builder(
      /* IMPORTANT */
      // Prevents error of rendering with the header of the main page
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      /* IMPORTANT */

      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Pokemons per row
      ),
      itemBuilder: (BuildContext context, int index) {
        final pokemon = items[index];
        return PokemonCard(pokemon: pokemon, index: index);
      },
    );

  }

}