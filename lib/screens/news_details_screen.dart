import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news_article.dart';
import '../provider/saved_articles_provider.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final savedProvider = Provider.of<SavedArticlesProvider>(context);
    final isSaved = savedProvider.isArticleSaved(article);

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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(article.description ?? 'No Description'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (isSaved) {
                  savedProvider.removeArticle(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article removed from saved list.')),
                  );
                } else {
                  savedProvider.saveArticle(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article saved!')),
                  );
                }
              },
              child: Text(isSaved ? 'Unsave' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
