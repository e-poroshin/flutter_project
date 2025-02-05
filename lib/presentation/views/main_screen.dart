import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'news_list_screen.dart';
import 'profile_screen.dart';
import 'saved_articles_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const NewsListScreen(),
    const SavedArticlesScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.article),
            label: localizations.translate('news'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark),
            label: localizations.translate('saved'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.translate('profile'),
          ),
        ],
      ),
    );
  }
}
