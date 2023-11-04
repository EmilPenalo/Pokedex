import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../style_variables.dart';

class LoadingScreen extends StatefulWidget {
  final int totalPokemonCount;
  final int loadingProgress;

  const LoadingScreen({
    super.key,
    required this.totalPokemonCount,
    required this.loadingProgress,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )
    ..repeat(reverse: true);

  late final Animation<double> _animation = Tween<double>(
    begin: 1.0,
    end: 2.0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ),
  );

  late final Animation<double> _rotateAnimation = Tween<double>(
    begin: 1.0,
    end: 2.5,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor(),
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
                scale: _animation,
                alignment: Alignment.center,
                child: Container(
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        RotationTransition(
                          turns: _animation,
                          child: SvgPicture.asset(
                            'lib/resources/pokeball_icon.svg',
                            width: 100,
                            height: 100,
                          ),
                        ),

                        RotationTransition(
                            turns: _rotateAnimation,
                            child: SizedBox(
                              width: 130,
                              height: 130,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue.shade200,
                                strokeAlign: CircularProgressIndicator
                                    .strokeAlignCenter,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeCap: StrokeCap.round,
                                value: 0.5,
                              ),
                            )
                        ),
                      ],
                    )
                )
            ),
          ),

          if (widget.totalPokemonCount != 0 && widget.loadingProgress != 0)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    "Loading Pokemons: ${widget.loadingProgress}/${widget
                        .totalPokemonCount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}