import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/local/news_local_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource newsLocalDataSource;

  NewsRepositoryImpl(this.newsLocalDataSource);

  @override
  Future<List<NewsArticle>> getNews() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in .env file');
    }

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Future<void> saveArticle(NewsArticle article) async {
    await newsLocalDataSource.saveArticle(article);
  }

  @override
  Future<void> removeArticle(NewsArticle article) async {
    await newsLocalDataSource.removeArticle(article);
  }

  @override
  Future<bool> isArticleSaved(NewsArticle article) async {
    return newsLocalDataSource.isArticleSaved(article);
  }

  @override
  Future<List<NewsArticle>> getSavedArticles() async {
    return newsLocalDataSource.getSavedArticles();
  }
}
