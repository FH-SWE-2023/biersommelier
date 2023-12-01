import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../DatabaseConnector.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps
    show LatLng;

class Bar {
  String id;
  String name;
  maps.LatLng location;
  String address;

  Bar(
      {required this.id,
      required this.name,
      required this.location,
      required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toString(),
      'address': address,
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
        address TEXT
      )
    ''';
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

  // Retrieve all bars from the database.
  static Future<List<Bar>> getAll() async {
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
}
