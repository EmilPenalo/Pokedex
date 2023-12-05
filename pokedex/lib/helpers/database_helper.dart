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
        "CREATE TABLE Pokemon(id INTEGER PRIMARY KEY, name TEXT NOT NULL, url TEXT NOT NULL, isCaptured BOOLEAN, type1 TEST NOT NULL, type2 TEXT);"
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

    const String apiUrl = 'https://beta.pokeapi.co/graphql/v1beta';
    const String query = '''
      query samplePokeAPIquery {
        pokemon: pokemon_v2_pokemon {
          id
          name
          types: pokemon_v2_pokemontypes {
            type: pokemon_v2_type {
              name
            }
          }
          specie: pokemon_v2_pokemonspecy {
            gen: pokemon_v2_generation {
              id
            }
          }
        }
      }
  ''';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'query': query,
    };

    totalPokemonCount = await getTotalPokemonCount();
    int loadedPokemonCount = 0;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> pokemonList = jsonData['data']['pokemon'];

      if (pokemonList.length != totalPokemonCount) {
        totalPokemonCount = pokemonList.length;

        for (var pokemonData in pokemonList) {
          final int id = pokemonData['id'];
          final String name = pokemonData['name'];
          final List<dynamic> types = pokemonData['types'];

          final existingPokemon = await db.query("Pokemon",
              where: 'id = ?', whereArgs: [id]);

          if (existingPokemon.isEmpty) {
            final newPokemon = Pokemon(
                name: name,
                isCaptured: false,
                id: id,
                type1: types[0]['type']['name'],
                type2: types.length == 2 ? types[1]['type']['name'] : null
            );
            addPokemon(newPokemon);
          } else {
            final updatedPokemon = Pokemon(
              name: name,
              isCaptured: existingPokemon[0]['isCaptured'] == 1,
              id: id,
              type1: types[0]['type']['name'],
              type2: types.length == 2 ? types[1]['type']['name'] : null,
            );
            updatePokemon(updatedPokemon);
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

  // Funciones de getters generales
  static Future<List<Pokemon>> getPokemonPaged(int limit, int offset) async {
    return _queryPokemon(limit, offset, null, null);
  }

  static Future<List<Pokemon>> getCapturedPokemonPaged(int limit, int offset) async {
    return _queryPokemon(limit, offset, 'isCaptured = ?', [1]);
  }

  // Busqueda individual por ID
  static Future<Pokemon?> getPokemonById(int id) async {
    final List<Pokemon> pokemonList = await _queryPokemon(1, 0, 'id = ?', [id]);

    if (pokemonList.isNotEmpty) {
      return pokemonList.first;
    } else {
      return null;
    }
  }

  // Get Pokemon ID por nombre
  static Future<int?> getPokemonIdByName(String name) async {
    final List<Pokemon> pokemonList = await _queryPokemon(1, 0, 'name = ?', [name]);

    if (pokemonList.isNotEmpty) {
      return pokemonList.first.id;
    } else {
      return null;
    }
  }

  // Busquedas paginadas segun id o nombre
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

  // Conteo de pokemons
  static Future<int> getTotalPokemonCount() async {
    final db = await _getDB();
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Pokemon')
    );

    return count ?? 0;
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