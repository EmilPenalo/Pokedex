import 'package:flutter/material.dart';

class ShinySelectorButton extends StatefulWidget {
  final dynamic Function() handler;
  final bool shiny;
  const ShinySelectorButton({super.key, required this.handler, required this.shiny});

  @override
  State<ShinySelectorButton> createState() => _ShinySelectorButtonState();
}

class _ShinySelectorButtonState extends State<ShinySelectorButton> {

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (widget.shiny) {
      icon = const Icon(Icons.auto_awesome, size: 22, color: Colors.white);
    } else {
      icon = const Icon(Icons.auto_awesome_outlined, size: 22, color: Colors.white);
    }

    return IconButton(
        onPressed: () => widget.handler(),
        icon: icon
    );
  }
}
