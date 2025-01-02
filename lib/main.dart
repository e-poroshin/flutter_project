import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'models/news_article.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewsProvider()..fetchArticles(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsProvider extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  List<NewsArticle> get articles => _articles;

  bool get isLoading => _isLoading;

  Future<void> fetchArticles() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in .env file');
    }

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List)
            .map((json) => NewsArticle.fromJson(json))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('News List')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: provider.articles.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final article = provider.articles[index];
                return ListTile(
                  title: Text(article.title ?? 'No Title'),
                  subtitle: Text(article.source ?? 'Unknown Source'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.fetchArticles,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox(height: 0),
            const SizedBox(height: 16),
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(article.description ?? 'No Description',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Source: ${article.source ?? 'Unknown'}',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
