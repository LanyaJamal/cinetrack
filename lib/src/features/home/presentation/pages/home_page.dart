import 'package:cinetrack/src/features/movies/presentation/pages/search_page.dart';
import 'package:cinetrack/src/features/movies/presentation/pages/trending_page.dart';
import 'package:cinetrack/src/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [TrendingPage(), SearchPage(), WatchlistPage()],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.outlineVariant, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.local_fire_department_outlined),
              selectedIcon: Icon(Icons.local_fire_department),
              label: 'Trending',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Watchlist',
            ),
          ],
        ),
      ),
    );
  }
}
