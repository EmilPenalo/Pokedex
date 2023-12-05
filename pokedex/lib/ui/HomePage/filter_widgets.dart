import 'package:flutter/material.dart';
import 'package:pokedex/style_variables.dart';
import '../Pokemon/pokemon_types.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {

  Color buttonColor = Colors.blueGrey[200]!;
  Icon buttonIcon = const Icon(Icons.filter_alt_off, color: Colors.white);

  @override
  initState() {
    super.initState();
  }

  handlePressed() {
    setState(() {
      buttonColor = primaryColor();
      buttonIcon = const Icon(Icons.filter_alt, color: Colors.white);
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (BuildContext context) {
        return filterSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: handlePressed,
      backgroundColor: buttonColor,
      elevation: 10,
      splashColor: Colors.blueGrey[300],
      child: buttonIcon,
    );
  }
}

Widget filterSheet() {
  return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                color: primaryColor(),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
            ),
            child: Center(
              child: Text(
                'Select type',
                style: headingTextStyleButColorType(Colors.white),
              ),
            ),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.white,
          ),
          Container(
            height: 368,
            width: double.infinity,
            color: Colors.white,
            child: ListView.builder(
                itemCount: pokemonTypesDictionary.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => print(pokemonTypesDictionary[index]),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: getPokemonTypeColor(pokemonTypesDictionary[index]),
                          width: 1,
                        ),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          pokemonTypesDictionary[index],
                          style: baseTextStyleButColorType(getPokemonTypeColor(pokemonTypesDictionary[index])),
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      )
  );
}
