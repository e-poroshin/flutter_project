import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class RemoveArticleUseCase {
  final NewsRepository repository;

  RemoveArticleUseCase(this.repository);

  Future<void> call(NewsArticle article) async {
    await repository.removeArticle(article);
  }
}
