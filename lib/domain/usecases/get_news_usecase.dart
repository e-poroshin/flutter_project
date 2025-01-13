import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  Future<List<NewsArticle>> call() {
    return repository.getNews();
  }
}
