import 'package:cinetrack/src/app/routes.dart';
import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:cinetrack/src/core/common/widgets/error_view.dart';
import 'package:cinetrack/src/core/common/widgets/loading_view.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/presentation/logic/search_notifier.dart';
import 'package:cinetrack/src/features/movies/presentation/widgets/movie_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    ref.read(searchQueryProvider.notifier).update(_controller.text);
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).submit('');
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                onSubmitted: ref.read(searchQueryProvider.notifier).submit,
                decoration: InputDecoration(
                  hintText: 'Search movies',
                  prefixIcon: const Icon(Icons.search_rounded, size: 21),
                  suffixIcon: _hasText
                      ? IconButton(
                          onPressed: _clear,
                          icon: const Icon(Icons.cancel, size: 19),
                          tooltip: 'Clear',
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: query.isEmpty
                  ? const EmptyView(
                      icon: Icons.search_rounded,
                      title: 'Search TMDB',
                      message: 'Type a title to find a movie.',
                    )
                  : switch (results) {
                      AsyncValue(isLoading: true, hasValue: false) =>
                        const LoadingView(),
                      AsyncData(:final value) =>
                        value.isEmpty
                            ? EmptyView(
                                icon: Icons.search_off_rounded,
                                title: 'No matches',
                                message: 'Nothing on TMDB matches "$query".',
                              )
                            : _SearchResults(movies: value),
                      AsyncError(:final error) => ErrorView(
                        error: error,
                        onRetry: () => ref.invalidate(searchResultsProvider),
                      ),
                      _ => const LoadingView(),
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.movies});

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: movies.length,
      itemBuilder: (context, index) => _tileFor(context, movies[index]),
    );
  }
}

Widget _tileFor(BuildContext context, MovieModel movie) {
  final heroTag = 'search-${movie.id}';
  return MovieListTile(
    movie: movie,
    heroTag: heroTag,
    onTap: () =>
        Navigator.of(context).push(movieDetailRoute(movie, heroTag: heroTag)),
  );
}
