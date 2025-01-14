import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class SaveArticleUseCase {
  final NewsRepository repository;

  SaveArticleUseCase(this.repository);

  Future<void> call(NewsArticle article) async {
    await repository.saveArticle(article);
  }
}
