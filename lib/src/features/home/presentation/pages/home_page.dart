import 'package:cinetrack/src/features/home/presentation/logic/tab_reselect_notifier.dart';
import 'package:cinetrack/src/features/movies/presentation/pages/search_page.dart';
import 'package:cinetrack/src/features/movies/presentation/pages/trending_page.dart';
import 'package:cinetrack/src/features/watchlist/presentation/logic/watchlist_notifier.dart';
import 'package:cinetrack/src/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      ref.read(tabReselectProvider.notifier).reselect(index);
      return;
    }
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
              icon: _WatchlistIcon(selected: false),
              selectedIcon: _WatchlistIcon(selected: true),
              label: 'Watchlist',
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistIcon extends ConsumerWidget {
  const _WatchlistIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      watchlistProvider.select((movies) => movies.length),
    );
    final colors = Theme.of(context).colorScheme;
    return Badge.count(
      count: count,
      isLabelVisible: count > 0,
      backgroundColor: colors.primary,
      textColor: colors.onPrimary,
      child: Icon(selected ? Icons.bookmark : Icons.bookmark_outline),
    );
  }
}
