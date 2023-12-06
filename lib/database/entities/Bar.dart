import 'package:biersommelier/components/DropdownInputField.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../DatabaseConnector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps
    show LatLng;

class Bar extends DropdownOption {
  String id;
  String name;
  maps.LatLng location;
  String address;
  bool isFavorite;

  Bar(
      {required this.id,
      required this.name,
      required this.location,
      required this.address,
      this.isFavorite = false}) : super(name: name, address: address, icon: "pin.png");

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toString(),
      'address': address,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Bar.fromMap(Map<String, dynamic> map) {
    return Bar(
      id: map['id'],
      name: map['name'],
      location: maps.LatLng(
        double.parse(map['location'].split('(')[1].split(',')[0]),
        double.parse(map['location'].split(',')[1].split(')')[0]),
      ),
      address: map['address'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  static String generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String createTable() {
    return '''
      CREATE TABLE IF NOT EXISTS bars(
        id TEXT PRIMARY KEY,
        name TEXT,
        location TEXT,
        address TEXT,
        isFavorite INTEGER
      )
    ''';
  }

  static Future<bool> updateTableColumns(Database db) async {
    List<String> columnsToAdd = [
      'id TEXT',
      'name TEXT',
      'location TEXT',
      'address TEXT',
      'isFavorite INTEGER',
    ];

    for (String column in columnsToAdd) {
      try {
        await db.execute('ALTER TABLE bars ADD $column');
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

  // Insert a new bar into the database.
  static Future<void> insert(Bar bar) async {
    final db = await DatabaseConnector().database;
    await db.insert(
      'bars',
      bar.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a bar in the database.
  static Future<void> update(Bar bar) async {
    final db = await DatabaseConnector().database;
    await db.update(
      'bars',
      bar.toMap(),
      where: 'id = ?',
      whereArgs: [bar.id],
    );
  }

  // Delete a bar from the database.
  static Future<void> delete(String id) async {
    final db = await DatabaseConnector().database;
    await db.delete(
      'bars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retrieve a bar from the database.
  static Future<Bar?> get(String id) async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps =
        await db.query('bars', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Bar.fromMap(maps.first);
    }

    return null;
  }

  // get by name
  static Future<Bar?> getByName(String name) async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps =
        await db.query('bars', where: 'name = ?', whereArgs: [name]);

    if (maps.isNotEmpty) {
      return Bar.fromMap(maps.first);
    }

    return null;
  }

  // Retrieve all bars from the database.
  static Future<List<Bar>> getAll({bool onlyFavorites = false}) async {
    if (onlyFavorites) {
      return getAllFavorites();
    }
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bars',
      orderBy: 'name COLLATE NOCASE ASC', // Sort alphabetically, ignoring case
      limit: 500,
    );

    return List.generate(maps.length, (i) {
      return Bar.fromMap(maps[i]);
    });
  }

  // Retrieve all favorite bars from the database.
  static Future<List<Bar>> getAllFavorites() async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bars',
      where: 'isFavorite = 1',
      orderBy: 'name COLLATE NOCASE ASC', // Sort alphabetically, ignoring case
      limit: 500,
    );

    return List.generate(maps.length, (i) {
      return Bar.fromMap(maps[i]);
    });
  }
}
