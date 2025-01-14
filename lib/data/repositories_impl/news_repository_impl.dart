import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/local/news_local_data_source.dart';
import '../datasources/remote/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource newsLocalDataSource;
  final NewsRemoteDataSource newsRemoteDataSource;

  NewsRepositoryImpl(this.newsLocalDataSource, this.newsRemoteDataSource);

  @override
  Future<List<NewsArticle>> fetchNews() async {
    return await newsRemoteDataSource.fetchNews();
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
