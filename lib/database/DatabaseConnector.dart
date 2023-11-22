import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'entities/Beer.dart' show Beer;
import 'entities/Bar.dart' show Bar;
import 'entities/Post.dart' show Post;

class DatabaseConnector {
  static Database? _database;

  // Private constructor to prevent direct instantiation.
  DatabaseConnector._privateConstructor();

  // Public factory constructor to access the singleton instance.
  factory DatabaseConnector() {
    return DatabaseConnector._privateConstructor();
  }

  // Get the database, if not initialized then initialize it.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database.
  Future<Database> _initDatabase() async {
    // Get the directory path for both Android and iOS to store the database.
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'biersommelier.db');

    // Open/create the database at the given path.
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create all the tables here
  Future _onCreate(Database db, int version) async {
    // TABLE CREATION HERE
    await db.execute(Beer.createTable());
    await db.execute(Bar.createTable());
    await db.execute(Post.createTable());
  }

  // Generic Query Execution, should not be used, just here for now
  // TODO: Remove this function before release
  Future<List<Map<String, dynamic>>> executeQuery(String sql) async {
    Database db = await database;
    return await db.rawQuery(sql);
  }
}
