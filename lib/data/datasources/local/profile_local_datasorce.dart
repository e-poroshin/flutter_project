import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/domain/entities/profile.dart';

class ProfileLocalDataSource {
  late Database _database;
  bool _isDatabaseInitialized = false;

  ProfileLocalDataSource() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'profile.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE profile(firstName TEXT, lastName TEXT, email TEXT)',
        );
      },
      version: 1,
    );
    _isDatabaseInitialized = true;
  }

  Future<Profile> getProfile() async {
    if (!_isDatabaseInitialized) {
      await _initDatabase();
    }
    final List<Map<String, dynamic>> profiles =
        await _database.query('profile');
    if (profiles.isNotEmpty) {
      return Profile.fromMap(profiles[0]);
    } else {
      throw Exception('Profile not found');
    }
  }

  Future<void> saveProfile(Profile profile) async {
    if (!_isDatabaseInitialized) {
      await _initDatabase();
    }
    await _database.delete('profile');
    await _database.insert(
      'profile',
      profile.toMap(),
    );
  }
}
