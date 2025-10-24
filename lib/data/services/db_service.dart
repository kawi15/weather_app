import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/favorite_city.dart';

class DBService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(FavoriteCity city) async {
    final db = await database;
    await db.insert('favorites', city.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(String name) async {
    final db = await database;
    await db.delete('favorites', where: 'name = ?', whereArgs: [name]);
  }

  Future<List<FavoriteCity>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites', orderBy: 'name ASC');
    return result.map((e) => FavoriteCity.fromMap(e)).toList();
  }
}