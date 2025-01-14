import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/domain/entities/news_article.dart';
import '/domain/usecases/get_saved_articles_usecase.dart';

class SavedArticlesViewModel extends ChangeNotifier {
  final GetSavedArticlesUseCase getSavedArticlesUseCase;

  SavedArticlesViewModel({required this.getSavedArticlesUseCase});

  List<NewsArticle> _savedArticles = [];

  List<NewsArticle> get savedArticles => _savedArticles;

  Future<void> fetchSavedArticles() async {
    _savedArticles = await getSavedArticlesUseCase();
    notifyListeners();
  }
}
