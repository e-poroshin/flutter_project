import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dependency_injection.dart';
import '../viewmodels/news_viewmodel.dart';
import 'news_details_screen.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<NewsViewModel>()..fetchNews(),
      child: Scaffold(
        appBar: AppBar(title: const Text('News List')),
        body: Consumer<NewsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: viewModel.fetchNews,
              child: ListView.separated(
                itemCount: viewModel.articles.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final article = viewModel.articles[index];
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
          },
        ),
      ),
    );
  }
}
