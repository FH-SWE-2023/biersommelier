import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../DatabaseConnector.dart';

class Beer {
  String id;
  String name;
  String imageId;

  Beer({required this.id, required this.name, required this.imageId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageId': imageId,
    };
  }

  factory Beer.fromMap(Map<String, dynamic> map) {
    return Beer(
      id: map['id'],
      name: map['name'],
      imageId: map['imageId'],
    );
  }

  static String generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String createTable() {
    return '''
      CREATE TABLE beers(
        id TEXT PRIMARY KEY,
        name TEXT,
        imageId TEXT
      )
    ''';
  }

  // Insert a new beer into the database.
  static Future<void> insert(Beer beer) async {
    final db = await DatabaseConnector().database;
    await db.insert(
      'beers',
      beer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a beer in the database.
  static Future<void> update(Beer beer) async {
    final db = await DatabaseConnector().database;
    await db.update(
      'beers',
      beer.toMap(),
      where: 'id = ?',
      whereArgs: [beer.id],
    );
  }

  // Delete a beer from the database.
  static Future<void> delete(String id) async {
    final db = await DatabaseConnector().database;
    await db.delete(
      'beers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retrieve a beer from the database.
  static Future<Beer?> get(String id) async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps =
        await db.query('beers', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Beer.fromMap(maps.first);
    }

    return null;
  }

  // Retrieve all beers from the database.
  static Future<List<Beer>> getAll() async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query('beers', limit: 500);

    return List.generate(maps.length, (i) {
      return Beer.fromMap(maps[i]);
    });
  }
}
