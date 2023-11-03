import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pokemon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Pokemon.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => 
      await db.execute(
        "CREATE TABLE Pokemon(id INTEGER PRIMARY KEY, name TEXT NOT NULL, url TEXT NOT NULL, isCaptured BOOLEAN);"
      ), version: _version
    );
  }

  // Inicialización de DB con pokemones
  static final StreamController<int> _progressStreamController =
  StreamController<int>.broadcast();

  static Stream<int> get progressStream => _progressStreamController.stream;

  static int totalPokemonCount = 0;

  static Future<void> fillDatabaseWithPokemon() async {
    final db = await _getDB();

    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final results = jsonData['results'];
      int loadedPokemonCount = 0;
      totalPokemonCount = results.length;

      if (results != null && results is List) {
        for (var pokemonData in results) {
          final name = pokemonData['name'];
          final url = pokemonData['url'];

          final existingPokemon = await db.query("Pokemon",
              where: 'url = ?', whereArgs: [url]);

          if (existingPokemon.isEmpty) {
            final newPokemon = Pokemon(name: name, url: url, isCaptured: false);
            await addPokemon(newPokemon);
          }

          loadedPokemonCount++;
          _progressStreamController.add(loadedPokemonCount);
        }
      }
    }
  }

  // CRUD Actions
  static Future<int> addPokemon(Pokemon pokemon) async {
    final db = await _getDB();
    return await db.insert(
        "Pokemon",
        pokemon.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> updatePokemon(Pokemon pokemon) async {
    final db = await _getDB();
    return await db.update(
      "Pokemon",
      pokemon.toJson(),
      where: 'id = ?',
      whereArgs: [pokemon.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Getters de Pokemons
  static Future<List<Pokemon>?> getAllPokemon() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Pokemon");

    if(maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) =>
        Pokemon.fromJson(maps[index])
    );
  }

  static Future<List<Pokemon>> getPokemonPaged(int limit, int offset) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      "Pokemon",
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (index) =>
        Pokemon.fromJson(maps[index])
    );
  }

  static Future<List<Pokemon>> getCapturedPokemonPaged(int limit, int offset) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      "Pokemon",
      limit: limit,
      offset: offset,
      where: 'isCaptured = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (index) =>
        Pokemon.fromJson(maps[index])
    );
  }

  // Clear DB para Debugging
  static Future<void> clearDatabase() async {
    final db = await _getDB();
    await db.delete("Pokemon");
  }

}