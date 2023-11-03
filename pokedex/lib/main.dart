import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pokedex/pages/pokemon_list.dart';

import 'helpers/database_helper.dart';
import 'ui/HomePageHeader/header_widgets.dart';
import 'style_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    title: 'POKEDEX',
    debugShowCheckedModeBanner: false,
    home: LoadingScreen(),
  ));

  await DatabaseHelper.fillDatabaseWithPokemon();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'POKEDEX',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context),
              sliver: SliverAppBar(
                backgroundColor: primaryColor(),
                expandedHeight: 300,
                collapsedHeight: 105,
                pinned: true,
                flexibleSpace: headerWidget(context),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.only(top: 130),
          color: primaryColor(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(top: 10),
            child: const PokemonList(),
          ),
        )
      ),
    );

  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..repeat(reverse: true);

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
      body: Center(
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
                      strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeCap: StrokeCap.round,
                      value: 0.5,
                    ),
                  )
                )

              ],
            )
          )
        ),
      ),
    );
  }

}







