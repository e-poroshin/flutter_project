import 'package:get_it/get_it.dart';

import 'data/repositories_impl/news_repository_impl.dart';
import 'domain/repositories/news_repository.dart';
import 'domain/usecases/get_news_usecase.dart';
import 'presentation/viewmodels/news_viewmodel.dart';

final sl = GetIt.instance;

void init() {
  // Register repositories_impl
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));

  // View models
  sl.registerFactory(() => NewsViewModel(sl()));
}
