import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/news_article.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  List<NewsArticle> get articles => _articles;

  bool get isLoading => _isLoading;

  Future<void> fetchArticles() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in .env file');
    }

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List)
            .map((json) => NewsArticle.fromJson(json))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
