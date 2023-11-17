import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokedex/helpers/text_helper.dart';

import '../../models/moves/pokemon_moves.dart';
import '../../models/moves/pokemons_move_info.dart';
import 'package:http/http.dart' as http;

import '../../style_variables.dart';
import '../Pokemon/pokemon_types.dart';

Future<List<PokemonMoveInfo>> fetchPokemonMoveInfo(List<Moves> moves) async {
  List<PokemonMoveInfo> results = [];

  for (Moves move in moves) {
    String url = move.move.url;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      results.add(PokemonMoveInfo.fromJson(responseData as Map<String, dynamic>));
    } else {
      throw Exception('Failed to load PokemonMoveInfo');
    }
  }

  return results;
}

class MoveList extends StatefulWidget {
  final List<Moves> moves;
  final Color color;
  const MoveList({Key? key, required this.moves, required this.color}) : super(key: key);

  @override
  State<MoveList> createState() => MoveListState();
}

class MoveListState extends State<MoveList> {
  static const _pageSize = 5;
  final PagingController<int, PokemonMoveInfo> _pagingController = PagingController(firstPageKey: 0);
  bool _disposed = false;
  late List<Moves> oldList = List.from(widget.moves);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_disposed) {
        return;
      }

      widget.moves.sort((a, b) => a.move.name.compareTo(b.move.name));

      final int startIndex = pageKey * _pageSize;

      int endIndex = startIndex + _pageSize;
      if (endIndex > widget.moves.length) {
        endIndex = widget.moves.length;
      }

      final List<Moves> movesForPage = widget.moves.sublist(startIndex, endIndex);

      final List<PokemonMoveInfo> newItems = await fetchPokemonMoveInfo(movesForPage);
      final bool isLastPage = endIndex >= widget.moves.length;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      if (!_disposed) {
        _pagingController.error = error;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!listEquals(oldList, widget.moves)) {
      setState(() {
        oldList = List.from(widget.moves);
        _pagingController.refresh();
      });
    }
    return RefreshIndicator(
      onRefresh: () =>
          Future.sync(
                () => _pagingController.refresh(),
          ),
      child: PagedListView<int, PokemonMoveInfo>(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<PokemonMoveInfo>(
          animateTransitions: true,

          itemBuilder: (context, item, index) =>
              Column(
                children: [
                  Container(
                    height: 2,
                    color: Colors.grey[100],
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            capitalizeFirstLetter(item.name),
                            style: baseTextStyle(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.power?.toString() ?? "-",
                            textAlign: TextAlign.center,
                            style: softerTextStyle(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.accuracy?.toString() ?? "-",
                            textAlign: TextAlign.center,
                            style: softerTextStyle()
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.pp.toString(),
                            textAlign: TextAlign.center,
                            style: softerTextStyle()
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: getPokemonTypeColor(capitalizeFirstLetter(item.damageClass.name)),
                                width: 1,
                              ),
                            ),
                            width: double.infinity,
                            child: Text(
                              capitalizeFirstLetter(item.damageClass.name),
                              style: softerTextStyle(),
                            ),
                          )
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.type.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _pagingController.dispose();
    super.dispose();
  }
}