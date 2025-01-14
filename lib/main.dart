import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/presentation/viewmodels/news_details_viewmodel.dart';
import 'package:test_flutter_project/presentation/viewmodels/saved_articles_viewmodel.dart';

import '../presentation/viewmodels/news_viewmodel.dart';
import 'application.dart';
import 'dependency_injection.dart' as di;

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
        //TODO
        // ChangeNotifierProvider(create: (context) => di.sl<ProfileViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}
