import 'package:flutter/material.dart';
import 'package:pokedex/helpers/database_helper.dart';
import 'package:pokedex/style_variables.dart';
import '../Pokemon/pokemon_types.dart';

class FilterButtons extends StatefulWidget {
  final Function genUpdate;
  final Function typeUpdate;
  const FilterButtons({super.key, required this.genUpdate, required this.typeUpdate});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {

  handleTypeOpen() {
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
                initialChildSize: 0.57,
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return filterTypeSheet(
                      controller: scrollController,
                      context: context,
                      handleSelect: handleTypeSelect
                  );
                }),
          );
        }
    );
  }

  handleGenOpen() {
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
                initialChildSize: 0.57,
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return filterGenSheet(
                      controller: scrollController,
                      context: context,
                      handleSelect: handleGenSelect
                  );
                }),
          );
        }
    );
  }

  Color typeColor = Colors.grey.shade200;
  String typeText = "All types";
  TextStyle typeStyle = inactiveFilterTextStyle();

  Color genColor = Colors.grey.shade200;
  String genText = "All gens";
  TextStyle genStyle = inactiveFilterTextStyle();

  handleTypeSelect(String type) {
    setState(() {
      typeText = type;
      if (type == "All types") {
        widget.typeUpdate("");
        typeColor = Colors.grey.shade200;
        typeStyle = inactiveFilterTextStyle();
      } else {
        widget.typeUpdate(type.toLowerCase());
        typeColor = getPokemonTypeColor(type);
        typeStyle = activeFilterTextStyle();
      }
    });
  }

  handleGenSelect(String gen) {
    setState(() {
      genText = gen;
      if (gen == "All gens") {
        widget.genUpdate(0);
        genColor = Colors.grey.shade200;
        genStyle = inactiveFilterTextStyle();
      } else {
        widget.genUpdate(getGenNumber(gen));
        genColor = Colors.blueGrey.shade300;
        genStyle = activeFilterTextStyle();
      }
    });
  }

  int getGenNumber(String input) {
    String lastPart = input.split(' ').last;
    int genNumber = int.tryParse(lastPart) ?? 0;

    return genNumber;
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          filterButton(
            openModal: handleGenOpen,
            backgroundColor: genColor,
            text: genText,
            style: genStyle,
            direction: 'left'
          ),
          Container(
            color: Colors.grey.shade300,
            width: 1,
          ),
          filterButton(
            openModal: handleTypeOpen,
            backgroundColor: typeColor,
            text: typeText,
            style: typeStyle,
            direction: 'right'
          ),
        ],
      ),
    );
  }
}

Widget filterButton({
  required Function openModal,
  required Color backgroundColor,
  required String text,
  required TextStyle style,
  required String direction,
}) {
    BorderRadius borderRadius;
    double shadowOffset = 0;
    if (direction == 'left') {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(20),
      );
      shadowOffset = -3;
    } else {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(20),
      );
      shadowOffset = 3;
    }

    return Expanded(
    child: GestureDetector(
      onTap: () {
        openModal();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(shadowOffset, 0),
            ),
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(13),
            alignment: Alignment.topCenter,
            child: Text(
              text,
              style: style,
            )),
      ),
    ),
  );
}


Widget filterTypeSheet({
  required ScrollController controller,
  required BuildContext context,
  required Function(String type) handleSelect
}) {

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
                        handleSelect(pokemonTypesDictionary[index]);
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

Widget filterGenSheet({
  required ScrollController controller,
  required BuildContext context,
  required Function(String type) handleSelect
}) {
  List<String> generationsList = ["All gens"];

  for (int i = 1; i <= DatabaseHelper.genCount; i++) {
    generationsList.add("Gen $i");
  }

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
                    handleSelect(generationsList[index]);
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