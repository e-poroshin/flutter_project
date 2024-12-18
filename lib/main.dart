import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/news_article.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    const apiKey = '3b6efad461c04c7e9195f44b42552d15';
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          final data = json.decode(response.body);
          _articles = (data['articles'] as List)
              .map((json) => NewsArticle.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News List')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _articles.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final article = _articles[index];
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
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Details')),
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
                : SizedBox(height: 0),
            SizedBox(height: 16),
            Text(
              article.title ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(article.description ?? 'No Description',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Source: ${article.source ?? 'Unknown'}',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}