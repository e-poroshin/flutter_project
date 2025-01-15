import 'package:get_it/get_it.dart';

import 'data/datasources/local/news_local_data_source.dart';
import 'data/datasources/local/profile_local_datasorce.dart';
import 'data/datasources/remote/news_remote_data_source.dart';
import 'data/repositories_impl/news_repository_impl.dart';
import 'data/repositories_impl/profile_repository_impl.dart';
import 'domain/repositories/news_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/get_news_usecase.dart';
import 'domain/usecases/get_profile_usecase.dart';
import 'domain/usecases/get_saved_articles_usecase.dart';
import 'domain/usecases/is_article_saved_usecase.dart';
import 'domain/usecases/remove_article_usecase.dart';
import 'domain/usecases/save_article_usecase.dart';
import 'domain/usecases/save_profile_usecase.dart';
import 'presentation/viewmodels/news_details_viewmodel.dart';
import 'presentation/viewmodels/news_viewmodel.dart';
import 'presentation/viewmodels/profile_viewmodel.dart';
import 'presentation/viewmodels/saved_articles_viewmodel.dart';

final sl = GetIt.instance;

void init() {
  // Register datasource
  sl.registerLazySingleton(() => NewsLocalDataSource());
  sl.registerLazySingleton(() => NewsRemoteDataSource());
  sl.registerLazySingleton(() => ProfileLocalDataSource());

  // Repositories
  sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => FetchNewsUseCase(sl()));
  sl.registerLazySingleton(() => SaveArticleUseCase(sl()));
  sl.registerLazySingleton(() => RemoveArticleUseCase(sl()));
  sl.registerLazySingleton(() => IsArticleSavedUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedArticlesUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => SaveProfileUseCase(sl()));

  // View models
  sl.registerFactory(() => NewsViewModel(sl()));
  sl.registerFactory(() => NewsDetailViewModel(
        saveArticleUseCase: sl(),
        removeArticleUseCase: sl(),
        isArticleSavedUseCase: sl(),
      ));
  sl.registerFactory(
      () => SavedArticlesViewModel(getSavedArticlesUseCase: sl()));
  sl.registerFactory(() =>
      ProfileViewModel(getProfileUseCase: sl(), saveProfileUseCase: sl()));
}
