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

  // Getter de pokemones generico
  static Future<List<Pokemon>> _queryPokemon(
      int limit,
      int offset,
      String? whereClause,
      List<dynamic>? whereArgs,
      ) async {
    final db = await _getDB();

    List<Map<String, dynamic>> maps = await db.query(
      "Pokemon",
      limit: limit,
      offset: offset,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return maps.map((map) => Pokemon.fromJson(map)).toList();
  }

  // Funciones de getters especificos
  static Future<List<Pokemon>> getPokemonPaged(int limit, int offset) async {
    return _queryPokemon(limit, offset, null, null);
  }

  static Future<List<Pokemon>> getCapturedPokemonPaged(int limit, int offset) async {
    return _queryPokemon(limit, offset, 'isCaptured = ?', [1]);
  }

  // Busquedas segun id o nombre
  static Future<List<Pokemon>> searchPokemonPaged(int limit, int offset, String searchTerm) async {
    if (isNumeric(searchTerm)) {
      int searchTermAsId = int.parse(searchTerm);
      return _queryPokemon(limit, offset, 'id = ?', [searchTermAsId]);
    } else {
      return _queryPokemon(limit, offset, 'name LIKE ?', ['%$searchTerm%']);
    }
  }

  static Future<List<Pokemon>> searchCapturedPokemonPaged(int limit, int offset, String searchTerm) async {
    if (isNumeric(searchTerm)) {
      int searchTermAsId = int.parse(searchTerm);
      return _queryPokemon(limit, offset, 'id = ? AND isCaptured = ?', [searchTermAsId, 1]);
    } else {
      return _queryPokemon(limit, offset, 'name LIKE ? AND isCaptured = ?', ['%$searchTerm%', 1]);
    }
  }

  // Clear DB para Debugging
  static Future<void> clearDatabase() async {
    final db = await _getDB();
    await db.delete("Pokemon");
  }

  // Helper functions
  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

}