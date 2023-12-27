import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'entities/Beer.dart' show Beer;
import 'entities/Bar.dart' show Bar;
import 'entities/MapCenter.dart';
import 'entities/Post.dart' show Post;

class DatabaseConnector {
  static Database? _database;

  bool _isFirstLaunch = false;

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

  get isFirstLaunch => _isFirstLaunch;

  void introductionComplete() {
    _isFirstLaunch = false;
  }

  // Initialize the database.
  Future<Database> _initDatabase() async {
    // Get the directory path for both Android and iOS to store the database.
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'biersommelier.db');

    // Open/create the database at the given path.
    return await openDatabase(path, version: 1, onCreate: _onCreate, onOpen: _onOpen);
  }

  // Create all the tables here
  Future _onCreate(Database db, int version) async {
    _isFirstLaunch = true;

    await db.execute(Beer.createTable());
    await db.execute(Bar.createTable());
    await db.execute(Post.createTable());
    await db.execute(MapCenter.createTable());

    // Create default entities
    await db.execute(Bar.createDefaultBars());
    await db.execute(Beer.createDefaultBeers());
    await db.execute(MapCenter.createDefaultMapCenter());
  }

  // op open create tables if not exists
  Future _onOpen(Database db) async {
    await db.execute(Beer.createTable());
    await db.execute(Bar.createTable());
    await db.execute(Post.createTable());
    await db.execute(MapCenter.createTable());

    // Update tables
    await Beer.updateTableColumns(db);
    await Bar.updateTableColumns(db);
    await Post.updateTableColumns(db);
    await MapCenter.updateTableColumns(db);
  }

  // Generic Query Execution, should not be used, just here for now
  // TODO: Remove this function before release
  @Deprecated('Methods for every entity are implemented')
  Future<List<Map<String, dynamic>>> executeQuery(String sql) async {
    Database db = await database;
    return await db.rawQuery(sql);
  }
}
