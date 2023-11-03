import 'package:flutter/material.dart';
import 'package:pokedex/helpers/database_helper.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'card_item.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  static const _pageSize = 20;
  final PagingController<int, Pokemon> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await DatabaseHelper.getPokemonPaged(_pageSize, pageKey*_pageSize);

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

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
    ),
    child: PagedGridView<int, Pokemon>(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Pokemon>(
        animateTransitions: true,

        itemBuilder: (context, item, index) => PokemonCard(
          pokemon: item,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    ),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}