import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProfileProvider extends ChangeNotifier {
  late Database _database;
  String _firstName = '';
  String _lastName = '';
  String _email = '';

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;

  ProfileProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/profile_data.db';
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            email TEXT
          )
        ''');
      },
    );
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    final List<Map<String, dynamic>> maps = await _database.query('profile');
    if (maps.isNotEmpty) {
      final data = maps.first;
      _firstName = data['firstName'] ?? '';
      _lastName = data['lastName'] ?? '';
      _email = data['email'] ?? '';
      notifyListeners();
    }
  }

  Future<void> saveProfile(
      String firstName, String lastName, String email) async {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;

    await _database.insert(
      'profile',
      {'firstName': firstName, 'lastName': lastName, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }
}
