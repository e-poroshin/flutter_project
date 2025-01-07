import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'provider/news_provider.dart';
import 'provider/profile_provider.dart';
import 'provider/saved_articles_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NewsProvider()..fetchArticles()),
        ChangeNotifierProvider(create: (context) => SavedArticlesProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
