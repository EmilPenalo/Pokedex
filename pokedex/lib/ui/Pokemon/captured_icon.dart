import 'package:flutter/material.dart';
import 'package:pokedex/ui/Pokemon/card_item_widgets.dart';


class CapturedIcon extends StatefulWidget {
  final bool captured;
  const CapturedIcon({super.key, required this.captured});

  @override
  State<CapturedIcon> createState() => _CapturedIconState();
}

class _CapturedIconState extends State<CapturedIcon> with TickerProviderStateMixin {

  late bool oldCaptured;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    oldCaptured = widget.captured;

    if (widget.captured) {
      _animation = const AlwaysStoppedAnimation(1.0);
    } else {
      _animation = const AlwaysStoppedAnimation(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.captured != oldCaptured) {
      oldCaptured = widget.captured;

      if (widget.captured) {
        _animation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(_controller);
        _controller.forward();
      } else {
        _animation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(_controller);
        _controller.reverse();
      }
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(17),
      ),
      child: ScaleTransition(
        scale: _animation,
        alignment: Alignment.topLeft,
        child: likedIcon()
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
