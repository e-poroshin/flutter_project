import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'dependency_injection.dart' as di;
import 'presentation/viewmodels/news_details_viewmodel.dart';
import 'presentation/viewmodels/news_viewmodel.dart';
import 'presentation/viewmodels/profile_viewmodel.dart';
import 'presentation/viewmodels/saved_articles_viewmodel.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<NewsViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.sl<NewsDetailViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.sl<SavedArticlesViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<ProfileViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}
