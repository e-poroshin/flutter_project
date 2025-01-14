import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dependency_injection.dart';
import '../../domain/entities/news_article.dart';
import '../viewmodels/news_details_viewmodel.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<NewsDetailViewModel>()..checkIfArticleIsSaved(article),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News Details'),
          actions: [
            Consumer<NewsDetailViewModel>(
              builder: (context, viewModel, child) {
                return IconButton(
                  icon: Icon(viewModel.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  onPressed: () {
                    viewModel.toggleSaveArticle(article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.isSaved
                            ? 'Article removed from saved list.'
                            : 'Article saved!'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(article.description ?? 'No Description'),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
