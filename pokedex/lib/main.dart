import 'package:flutter/material.dart';
import 'package:pokedex/pages/loading_screen.dart';
import 'package:pokedex/pages/pokemon_list.dart';
import 'package:pokedex/ui/HomePage/filter_widgets.dart';
import 'helpers/database_helper.dart';
import 'ui/HomePage/header_widgets.dart';
import 'style_variables.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializePreferences();

  // DatabaseHelper.clearDatabase();

  runApp(
    MaterialApp(
      title: 'POKEDEX',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<int>(
        stream: DatabaseHelper.progressStream,
        builder: (context, snapshot) {
          return LoadingScreen(
            loadingProgress: snapshot.data ?? 0,
            totalPokemonCount: DatabaseHelper.totalPokemonCount,
          );
        },
      ),
    ),
  );

  await DatabaseHelper.fillDatabaseWithPokemon();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const MaterialApp(
      title: 'POKEDEX',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String typeFilter = "";
  int genFilter = 0;
  final TextEditingController searchController = TextEditingController();

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
                  flexibleSpace: headerWidget(context, updateSearchQuery, searchController),
                ),
              ),
            ];
          },
          body: Container(
            padding: const EdgeInsets.only(top: 135),
            color: primaryColor(),
            child: Stack(
              children: [

                // Filtros
                FilterButtons(
                  genUpdate: updateGenFilter,
                  typeUpdate: updateTypeFilter,
                ),

                // Listado de Pokemons
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 7,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  child: PokemonList(captured: false, searchTerm: searchQuery, gen: genFilter, type: typeFilter),
                ),
              ],
            ),
          ),
      ),
    );
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }
  void updateGenFilter(int gen) {
    setState(() {
      genFilter = gen;
    });
  }
  void updateTypeFilter(String type) {
    setState(() {
      typeFilter = type;
    });
  }
}