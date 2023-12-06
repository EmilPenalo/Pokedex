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
      isScrollControlled: true,
      builder: (BuildContext context) {
        return makeDismissible(
          context: context,
          child: DraggableScrollableSheet(
            maxChildSize: 0.9,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return filterTypeSheet(scrollController, context);
            }),
        );
        }
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

Widget filterTypeSheet(ScrollController controller, BuildContext context) {
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
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  controller: controller,
                  itemCount: pokemonTypesDictionary.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(pokemonTypesDictionary[index]);
                        Navigator.of(context).pop();
                      },
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
            ),
          )
        ],
      )
  );
}

Widget filterGenSheet(ScrollController controller, BuildContext context) {
  List<String> generationsList = ["All gens", "Gen 1", "Gen 2", "Gen 3", "Gen 4", "Gen 5", "Gen 6", "Gen 7", "Gen 8", "Gen 9"];

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
            ),
          ),
          child: Center(
            child: Text(
              'Select Gen',
              style: headingTextStyleButColorType(Colors.white),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              controller: controller,
              itemCount: generationsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(generationsList[index]);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: getPokemonTypeColor(generationsList[index]),
                        width: 1,
                      ),
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        generationsList[index],
                        style: baseTextStyleButColorType(getPokemonTypeColor(generationsList[index])),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget makeDismissible({required Widget child, required context}) => GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => Navigator.of(context).pop(),
  child: GestureDetector(onTap: () {}, child: child),
);

class SizedBoxFilter extends StatelessWidget {
  const SizedBoxFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Clicked Gens");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(-3, 0),
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "All Gens",
                      // style: softerTextStyle(),
                    )),
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            width: 1,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Clicked Types");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "All Types",
                      // style: softerTextStyle(),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}