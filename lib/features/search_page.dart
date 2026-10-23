import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../widgets/music_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  bool _showHistory = false, _allSongs = false;
  String _query = '';
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.trim().isNotEmpty;
    final results = Catalog.search(_query);
    return ListView(
      key: const PageStorageKey('search-scroll'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const PageTitle('Search'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 46,
            child: TextField(
              key: const ValueKey('search-input'),
              controller: _controller,
              onChanged: (value) => setState(() => _query = value),
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Type song name, album . . .',
                hintStyle: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.muted,
                  size: 23,
                ),
                suffixIcon: hasQuery
                    ? IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close, size: 18),
                      )
                    : null,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: hasQuery ? AppColors.blue : AppColors.pale,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
              ),
            ),
          ),
        ),
        if (!hasQuery) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.muted.withValues(alpha: .08),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            child: Wrap(
              spacing: 6,
              children: [
                const Text('Trending:', style: TextStyle(fontSize: 13.5)),
                ...['Pitbull', 'Beyonce', 'Single', 'Classic'].map(
                  (q) => InkWell(
                    onTap: () {
                      _controller.text = q;
                      setState(() => _query = q);
                    },
                    child: Text(
                      q,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          SectionTitle(
            'Search History',
            onShowAll: () => setState(() => _showHistory = !_showHistory),
          ),
          ...(_showHistory ? Catalog.trending : Catalog.trending.take(3)).map(
            (t) => TrackTile(t),
          ),
          const SizedBox(height: 30),
          const SectionTitle('Searched Artist'),
          const ArtistRail(),
        ] else if (results.isEmpty) ...[
          const SizedBox(height: 65),
          const Icon(CupertinoIcons.search, color: AppColors.pale, size: 48),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              'Try a song, artist or genre, such as Gully Boy or Pop.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        ] else ...[
          const SizedBox(height: 32),
          const SectionTitle('Most Popular'),
          TrackTile(
            results.first,
            subtitle: 'Song  |  ${results.first.title}',
            from: results,
          ),
          const SizedBox(height: 16),
          SectionTitle(
            'Songs',
            onShowAll: () => setState(() => _allSongs = !_allSongs),
          ),
          ...(_allSongs
                  ? results
                  : results.skip(results.length > 1 ? 1 : 0).take(5))
              .map(
                (t) => TrackTile(
                  t,
                  subtitle:
                      '${t.genre == 'Hip Hop' ? 'Album, 2019' : 'Song'}  |  Gully Boy',
                  from: results,
                ),
              ),
          if ('gully boy'.contains(_query.toLowerCase()) ||
              _query.toLowerCase().contains('gully')) ...[
            const SizedBox(height: 18),
            const SectionTitle('Albums'),
            const AlbumRail(Catalog.searchAlbums),
          ],
          const SizedBox(height: 24),
          const SectionTitle('Artists'),
          const ArtistRail(),
        ],
        const SizedBox(height: 28),
      ],
    );
  }
}
