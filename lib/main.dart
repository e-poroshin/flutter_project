import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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
        // ChangeNotifierProvider(create: (context) => di.sl<ProfileViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}
