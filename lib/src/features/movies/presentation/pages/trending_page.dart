import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:flutter/material.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending')),
      body: const SafeArea(
        top: false,
        child: EmptyView(
          icon: Icons.local_fire_department_outlined,
          title: 'Nothing trending yet',
          message: "Today's most watched movies will appear here.",
        ),
      ),
    );
  }
}
