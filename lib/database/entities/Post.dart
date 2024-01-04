import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../DatabaseConnector.dart';

import 'Beer.dart';
import 'Bar.dart';

class Post {
  String id;
  String imageId;
  int rating;
  String barId;
  String beerId;
  DateTime date;
  String description;

  Post(
      {required this.id,
      required this.imageId,
      required this.rating,
      required this.barId,
      required this.beerId,
      required this.date,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageId': imageId,
      'rating': rating,
      'barId': barId,
      'beerId': beerId,
      'date': date.toString(),
      'description': description,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      imageId: map['imageId'],
      rating: map['rating'],
      barId: map['barId'],
      beerId: map['beerId'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }

  // function to get Beer object from Post object
  static Future<Beer?> getBeer(Post post) async {
    return await Beer.get(post.beerId);
  }

  // function to get Bar object from Post object
  static Future<Bar?> getBar(Post post) async {
    return await Bar.get(post.barId);
  }

  static String generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String createTable() {
    return '''
      CREATE TABLE IF NOT EXISTS posts(
        id TEXT PRIMARY KEY,
        imageId TEXT,
        rating INTEGER,
        barId TEXT,
        beerId TEXT,
        date TEXT,
        description TEXT
      )
    ''';
  }

  static Future<bool> updateTableColumns(Database db) async {
    List<String> columnsToAdd = [
      'id TEXT',
      'imageId TEXT',
      'rating INTEGER',
      'barId TEXT',
      'beerId TEXT',
      'date TEXT',
      'description TEXT'
    ];

    for (String column in columnsToAdd) {
      try {
        await db.execute('ALTER TABLE posts ADD $column');
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

  // Insert a new Post into the database.
  static Future<void> insert(Post post) async {
    final db = await DatabaseConnector.database;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a Post in the database.
  static Future<void> update(Post post) async {
    final db = await DatabaseConnector.database;
    await db.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  // Delete a Post from the database.
  static Future<void> delete(String id) async {
    final db = await DatabaseConnector.database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retrieve a post from the database.
  static Future<Post?> get(String id) async {
    final db = await DatabaseConnector.database;
    final List<Map<String, dynamic>> maps =
        await db.query('posts', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Post.fromMap(maps.first);
    }

    return null;
  }

  // Retrieve all Posts from the database.
  static Future<List<Post>> getAll() async {
    final db = await DatabaseConnector.database;
    final List<Map<String, dynamic>> maps =
        await db.query('posts', limit: 500, orderBy: 'date desc');

    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }
}
