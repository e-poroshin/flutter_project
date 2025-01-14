import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/news_article.dart';

class NewsLocalDataSource extends ChangeNotifier {
  late Database _database;
  List<NewsArticle> _savedArticles = [];
  bool _isDatabaseInitialized = false;

  NewsLocalDataSource() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/saved_articles.db';
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE articles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            urlToImage TEXT,
            source TEXT
          )
        ''');
      },
    );
    _isDatabaseInitialized = true;
    await _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    final List<Map<String, dynamic>> maps = await _database.query('articles');
    _savedArticles = maps.map((map) => NewsArticle.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> saveArticle(NewsArticle article) async {
    if (!_savedArticles.any((saved) => saved.title == article.title)) {
      await _database.insert('articles', article.toMap());
      _savedArticles.add(article);
      notifyListeners();
    }
  }

  Future<void> removeArticle(NewsArticle article) async {
    await _database.delete(
      'articles',
      where: 'title = ?',
      whereArgs: [article.title],
    );
    _savedArticles.removeWhere((saved) => saved.title == article.title);
    notifyListeners();
  }

  bool isArticleSaved(NewsArticle article) {
    return _savedArticles.any((saved) => saved.title == article.title);
  }

  Future<void> clearSavedArticles() async {
    await _database.delete('articles');
    _savedArticles.clear();
    notifyListeners();
  }

  Future<List<NewsArticle>> getSavedArticles() async {
    if (!_isDatabaseInitialized) {
      await _initDatabase();
    }
    return _savedArticles;
  }
}
