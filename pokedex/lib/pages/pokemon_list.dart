import 'package:flutter/material.dart';
import 'package:pokedex/helpers/database_helper.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'card_item.dart';

class PokemonList extends StatefulWidget {
  final bool captured;
  final String searchTerm;
  const PokemonList({Key? key, required this.captured, required this.searchTerm}) : super(key: key);

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  static const _pageSize = 20;
  final PagingController<int, Pokemon> _pagingController = PagingController(firstPageKey: 0);

  late String previousSearchTerm;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
    });

    previousSearchTerm = widget.searchTerm;

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<Pokemon> newItems = await _getPokemonList(pageKey, widget.searchTerm, widget.captured, "", 0);
      final isLastPage = newItems.length < _pageSize;

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

  Future<List<Pokemon>> _getPokemonList(int pageKey, String searchTerm, bool captured, String type, int gen) async {
    if (searchTerm.isEmpty) {
      return captured
          ? DatabaseHelper.getCapturedPokemonPaged(_pageSize, pageKey * _pageSize)
          : DatabaseHelper.searchPokemonFilteredPaged(_pageSize, pageKey * _pageSize, searchTerm, type, gen);
    } else {
      return captured
          ? DatabaseHelper.searchCapturedPokemonPaged(_pageSize, pageKey * _pageSize, searchTerm)
          : DatabaseHelper.searchPokemonFilteredPaged(_pageSize, pageKey * _pageSize, searchTerm, type, gen);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (previousSearchTerm != widget.searchTerm) {
      _pagingController.refresh();
      previousSearchTerm = widget.searchTerm;
    }

    return RefreshIndicator(
      onRefresh: () =>
          Future.sync(
                () => _pagingController.refresh(),
          ),
      child: PagedGridView<int, Pokemon>(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 70),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Pokemon>(
          animateTransitions: true,

          itemBuilder: (context, item, index) =>
              PokemonCard(
                pokemon: item,
              ),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}