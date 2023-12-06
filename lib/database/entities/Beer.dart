import 'package:biersommelier/components/DropdownInputField.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../DatabaseConnector.dart';

class Beer extends DropdownOption {
  String id;
  String name;
  String imageId;
  bool isFavorite;

  @override
  String? get address => null;

  Beer({required this.id, required this.name,required this.imageId, this.isFavorite = false}) : super(name: name, icon: 'beer.png');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageId': imageId,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Beer.fromMap(Map<String, dynamic> map) {
    return Beer(
      id: map['id'],
      name: map['name'],
      imageId: map['imageId'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  static String generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String createTable() {
    return '''
      CREATE TABLE IF NOT EXISTS beers(
        id TEXT PRIMARY KEY,
        name TEXT,
        imageId TEXT,
        isFavorite INTEGER
      )
    ''';
  }

  static List<String> updateTableColumns() {
    return [
      'id TEXT',
      'name TEXT',
      'imageId TEXT',
      'isFavorite INTEGER',
    ];
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

  // get by name
  static Future<Beer?> getByName(String name) async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps =
        await db.query('beers', where: 'name = ?', whereArgs: [name]);

    if (maps.isNotEmpty) {
      return Beer.fromMap(maps.first);
    }

    return null;
  }

  // Retrieve all beers from the database.
  static Future<List<Beer>> getAll({bool onlyFavorites = false}) async {
    if (onlyFavorites) {
      return getAllFavorites();
    }
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'beers',
      orderBy: 'name COLLATE NOCASE ASC', // Sort alphabetically, ignoring case
      limit: 500,
    );

    return List.generate(maps.length, (i) {
      return Beer.fromMap(maps[i]);
    });
  }

  // Retrieve all favourite beers from the database
  static Future<List<Beer>> getAllFavorites() async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'beers',
      where: 'isFavorite = 1',
      orderBy: 'name COLLATE NOCASE ASC', // Sort alphabetically, ignoring case
      limit: 500,
    );

    return List.generate(maps.length, (i) {
      return Beer.fromMap(maps[i]);
    });
  }
}
