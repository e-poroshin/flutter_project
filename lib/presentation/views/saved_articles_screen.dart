import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dependency_injection.dart';
import '../viewmodels/saved_articles_viewmodel.dart';
import 'news_details_screen.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  _SavedArticlesScreenState createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  late SavedArticlesViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<SavedArticlesViewModel>(context);
    _viewModel.getSavedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<SavedArticlesViewModel>()..getSavedArticles(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved articles')),
        body: Consumer<SavedArticlesViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.savedArticles.isEmpty
                ? const Center(child: Text('No saved items yet.'))
                : ListView.separated(
                    itemCount: viewModel.savedArticles.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final article = viewModel.savedArticles[index];
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
                  );
          },
        ),
      ),
    );
  }
}
