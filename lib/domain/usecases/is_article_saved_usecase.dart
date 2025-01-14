import '../entities/news_article.dart';
import '../repositories/news_repository.dart';

class IsArticleSavedUseCase {
  final NewsRepository repository;

  IsArticleSavedUseCase(this.repository);

  Future<bool> call(NewsArticle article) async {
    return await repository.isArticleSaved(article);
  }
}
