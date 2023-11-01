import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pokemon.dart';

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
}