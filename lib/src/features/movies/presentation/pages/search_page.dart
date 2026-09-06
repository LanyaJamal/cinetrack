import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const SafeArea(
        top: false,
        child: EmptyView(
          icon: Icons.search,
          title: 'Search movies',
          message: 'Find a title by name and open it for the full details.',
        ),
      ),
    );
  }
}
