import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';
import 'news_details_screen.dart';

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
