import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class FetchNewsUseCase {
  final NewsRepository repository;

  FetchNewsUseCase(this.repository);

  Future<List<NewsArticle>> call() {
    return repository.fetchNews();
  }
}
