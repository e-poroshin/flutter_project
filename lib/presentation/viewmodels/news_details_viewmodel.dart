import 'package:flutter/material.dart';

import '/domain/entities/news_article.dart';
import '/domain/usecases/is_article_saved_usecase.dart';
import '/domain/usecases/remove_article_usecase.dart';
import '/domain/usecases/save_article_usecase.dart';

class NewsDetailViewModel extends ChangeNotifier {
  final SaveArticleUseCase saveArticleUseCase;
  final RemoveArticleUseCase removeArticleUseCase;
  final IsArticleSavedUseCase isArticleSavedUseCase;

  NewsDetailViewModel({
    required this.saveArticleUseCase,
    required this.removeArticleUseCase,
    required this.isArticleSavedUseCase,
  });

  bool _isSaved = false;

  bool get isSaved => _isSaved;

  Future<void> checkIfArticleIsSaved(NewsArticle article) async {
    _isSaved = await isArticleSavedUseCase(article);
    notifyListeners();
  }

  Future<void> toggleSaveArticle(NewsArticle article) async {
    if (_isSaved) {
      await removeArticleUseCase(article);
    } else {
      await saveArticleUseCase(article);
    }
    _isSaved = !_isSaved;
    notifyListeners();
  }
}
