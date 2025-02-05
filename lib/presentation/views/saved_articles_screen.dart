import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dependency_injection.dart';
import '../../l10n/app_localizations.dart';
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
    var localizations = AppLocalizations.of(context);

    return ChangeNotifierProvider(
      create: (_) => sl<SavedArticlesViewModel>()..getSavedArticles(),
      child: Scaffold(
        appBar: AppBar(title: Text(localizations.translate('savedArticles'))),
        body: Consumer<SavedArticlesViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.savedArticles.isEmpty
                ? Center(child: Text(localizations.translate('noSavedArticles')))
                : ListView.separated(
                    itemCount: viewModel.savedArticles.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final article = viewModel.savedArticles[index];
                      return ListTile(
                        title: Text(article.title ?? localizations.translate('noTitle')),
                        subtitle: Text(article.source ?? localizations.translate('unknownSource')),
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
