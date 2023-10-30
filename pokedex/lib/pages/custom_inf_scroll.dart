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

  static const _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchPage();

    widget.scrollController.addListener(() {
      print("POS: " + widget.scrollController.position.pixels.toString() + " MAX: " + widget.scrollController.position.maxScrollExtent.toString());

      if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent) {
        print("Max Scroll Reached");
        _fetchPage();
      }
    });
  }

  void _fetchPage() async {

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      if (pageKey >= 0) {
        print("Fetching: " + pageKey.toString());
        final pokedex = await fetchPokedex(
            'https://pokeapi.co/api/v2/pokemon?limit=$_pageSize&offset=${pageKey *
                _pageSize}');
        final newItems = pokedex.results;
        print("Got em: ${newItems.length}");

        final isLastPage = pokedex.count < _pageSize;
        if (isLastPage) {
          setState(() {
            pageKey = -1;
          });
        } else {
          setState(() {
            pageKey = pageKey + 1;
          });
          print(pageKey);
        }
        items.addAll(newItems);
      }
    } catch (error) {
      print(error);

    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          /* IMPORTANT */
          // Previenen error de rendering con el header de la pagina principal
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            /* IMPORTANT */

            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Pokemons por fila
            ),

            itemBuilder: (BuildContext context, int index) {
              final pokemon = items[index];
              return PokemonCard(pokemon: pokemon, index: index);
            }
        ),
        Container(
          alignment: Alignment.topCenter,
          height: 60,
          child: IconButton(
              onPressed: () {
                _fetchPage();
              },
              icon: Icon(Icons.arrow_circle_down_rounded, color: Colors.grey[400], size: 30,)
          ),
        ),
      ],
    );
  }

}