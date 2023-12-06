import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/style_variables.dart';

import '../../pages/capture_pokemon_list.dart';
import '../../pages/transitions/routes.dart';

IconButton favoritesActionButton(BuildContext context) {
  return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 22,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
          ),
          child: SvgPicture.asset(
            'lib/resources/pokeball_icon.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),

      onPressed: () => handleFavoriteButtonClick(context),
  );
}

void handleFavoriteButtonClick(BuildContext context) {
  Navigator.of(context).push(
      createSlideRoute(const CapturePokemonList())
  );
}

Widget searchBar(Function(String) onSubmitted, TextEditingController searchController) {
  return Container(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
    height: 45,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
        child: TextField(
          controller: searchController,
          style: baseTextStyle(),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            onSubmitted(value);
          },
        ),
      ),
    ),
  );
}

Widget filterBars(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
            /*
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const FilterButton();
              },
            );

             */
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 4, 4, 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'All gens',
                    style: softerTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.filter_alt_off,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(4, 4, 8, 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(99)),
          ),
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'All types',
                  style: softerTextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.filter_alt_off,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}