import 'package:flutter/material.dart';

import '../../domain/entities/news_article.dart';
import '../../domain/usecases/get_news_usecase.dart';

class NewsViewModel extends ChangeNotifier {
  final FetchNewsUseCase fetchNewsUseCase;

  NewsViewModel(this.fetchNewsUseCase);

  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  List<NewsArticle> get articles => _articles;

  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();
    _articles = await fetchNewsUseCase();
    _isLoading = false;
    notifyListeners();
  }
}
