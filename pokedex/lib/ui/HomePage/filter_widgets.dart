import 'package:flutter/material.dart';
import 'package:pokedex/style_variables.dart';
import '../Details/detail_widgets.dart';

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
        return evolutionSheetPlaceholder(color: primaryColor());
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
