import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class GetSavedArticlesUseCase {
  final NewsRepository repository;

  GetSavedArticlesUseCase(this.repository);

  Future<List<NewsArticle>> call() async {
    return await repository.getSavedArticles();
  }
}
