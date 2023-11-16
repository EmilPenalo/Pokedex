import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/moves/pokemon_moves.dart';
import '../../models/moves/pokemons_move_info.dart';
import 'package:http/http.dart' as http;

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
              SizedBox(
                height: 100,
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                    ),
                    child: Center(
                      child: Text(item.name),
                    ),
                  ),
                ),
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