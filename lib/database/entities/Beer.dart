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

  static String createDefaultBeers() {
    return '''
      INSERT INTO beers (id, name, imageId, isFavorite) VALUES
      ('b007bec1-e6b0-4514-b741-895440d2619e', 'Kölsch', '', 0),
      ('88c58884-5dba-4296-9a74-21cc29b9db73', 'Berg Märzen', '', 0),
      ('ba8bb191-6c43-491f-99a8-4a3029440496', 'Dunkles', '', 0),
      ('1fbf011a-958b-4ebf-924b-5f7325a4c616', 'Duxer Bock', '', 0),
      ('3ddd3fbb-2ba3-4942-aed8-37371190651d', 'Berliner Weisse', '', 0),
      ('268fa825-3127-4e37-b7c4-3da4001f13ec', 'Feldschlösschen Pils', '', 0),
      ('92d646f8-49a9-4399-85db-6522da2674e2', 'Watzdorfer Schwarzbier', '', 0)
    ''';
  }

  static Future<bool> updateTableColumns(Database db) async {
    List<String> columnsToAdd = [
      'id TEXT',
      'name TEXT',
      'imageId TEXT',
      'isFavorite INTEGER'
    ];

    for (String column in columnsToAdd) {
      try {
        await db.execute('ALTER TABLE beers ADD $column');
      } catch (e) {
        // If there's an exception, it's likely because the column already exists.
        // In that case, we don't need to do anything.
        if (e.toString().contains('duplicate column name')) {
          continue;
        } else {
          rethrow;
        }
      }
    }
    return true;
  }

  static Future<void> toggleFavorite(String id) async {
    final db = await DatabaseConnector().database;
    final Beer? beer = await get(id);
    if (beer != null) {
      await db.update(
        'beers',
        {'isFavorite': beer.isFavorite ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
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
