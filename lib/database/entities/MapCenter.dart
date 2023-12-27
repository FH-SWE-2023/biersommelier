import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import '../DatabaseConnector.dart';

/// Singleton MapCenter Entity used to store the center of the map
class MapCenter {
  final double lat;
  final double lng;

  MapCenter({required this.lat, required this.lng});

  static Future<LatLng> get() async {
    final db = await DatabaseConnector().database;
    final List<Map<String, dynamic>> maps = await db.query('MapCenter');
    return LatLng(maps.first['lat'], maps.first['lng']);
  }

  static Future<void> set(LatLng location) async {
    final db = await DatabaseConnector().database;
    await db.update(
      'MapCenter',
      {
        'lat': location.latitude,
        'lng': location.longitude,
      },
    );
  }

  static String createTable() {
    return '''
     CREATE TABLE IF NOT EXISTS MapCenter (
       lat REAL NOT NULL DEFAULT 0.0,
       lng REAL NOT NULL DEFAULT 0.0
     )
   ''';
  }

  static String createDefaultMapCenter() {
    return '''
      INSERT INTO MapCenter (lat, lng) VALUES (50.775555, 6.083611)
    ''';
  }

  static Future<bool> updateTableColumns(Database db) async {
    List<String> columnsToAdd = [
      'lat REAL NOT NULL DEFAULT 0.0',
      'lng REAL NOT NULL DEFAULT 0.0',
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
}
