import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<List<NewsArticle>> fetchNews();

  Future<bool> isArticleSaved(NewsArticle article);

  Future<void> saveArticle(NewsArticle article);

  Future<void> removeArticle(NewsArticle article);

  Future<List<NewsArticle>> getSavedArticles();
}
