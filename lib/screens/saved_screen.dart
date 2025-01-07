import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/saved_articles_provider.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SavedArticlesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved articles')),
      body: provider.savedArticles.isEmpty
          ? const Center(child: Text('No saved items yet.'))
          : ListView.separated(
              itemCount: provider.savedArticles.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final article = provider.savedArticles[index];
                return ListTile(
                  title: Text(article.title ?? 'No Title'),
                  subtitle: Text(article.source ?? 'Unknown Source'),
                );
              },
            ),
    );
  }
}
