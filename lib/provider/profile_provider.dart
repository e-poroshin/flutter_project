import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//TODO remove
class ProfileProvider with ChangeNotifier {
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
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    final List<Map<String, dynamic>> profiles =
        await _database.query('profile');
    if (profiles.isNotEmpty) {
      _firstName = profiles[0]['firstName'] ?? '';
      _lastName = profiles[0]['lastName'] ?? '';
      _email = profiles[0]['email'] ?? '';
    }
    notifyListeners();
  }

  Future<void> saveProfile(
      String firstName, String lastName, String email) async {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;

    await _database.delete('profile');
    await _database.insert(
      'profile',
      {'firstName': firstName, 'lastName': lastName, 'email': email},
    );

    notifyListeners();
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }
}
