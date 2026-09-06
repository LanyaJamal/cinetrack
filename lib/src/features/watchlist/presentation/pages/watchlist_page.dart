import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: const SafeArea(
        top: false,
        child: EmptyView(
          icon: Icons.bookmark_outline,
          title: 'Your watchlist is empty',
          message: 'Movies you save are kept on this device, even offline.',
        ),
      ),
    );
  }
}
