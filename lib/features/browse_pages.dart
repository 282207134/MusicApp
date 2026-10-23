import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../widgets/music_widgets.dart';
import 'detail_pages.dart';
import 'player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onGenre});
  final ValueChanged<String> onGenre;
  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey('home-scroll'),
    children: [
      const PageTitle('Explore'),
      const SectionTitle('Recomanded for you'),
      const AlbumRail(Catalog.recommended),
      const SizedBox(height: 23),
      const SectionTitle('Recent Played'),
      SizedBox(
        height: 165,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final track = [
              Catalog.tracks[15],
              Catalog.tracks[0],
              Catalog.tracks[16],
            ][i];
            return SizedBox(
              width: 125,
              child: InkWell(
                onTap: () {
                  AppScope.of(context).playTrack(track);
                  openPage(context, const PlayerPage());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Cover(
                      ['guitar', 'rock', 'loca'][i],
                      width: 125,
                      height: 125,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ['No Time To Die', 'Illegal Weapon', 'Loca'][i],
                      maxLines: 1,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 20),
      const SectionTitle('New Released'),
      const AlbumRail(Catalog.released, size: 195),
      const SizedBox(height: 23),
      const SectionTitle('Popular Artist'),
      const ArtistRail(),
      const SizedBox(height: 20),
      const SectionTitle('Genres & Moods'),
      SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final genre = ['Hip Hop', 'Pop', 'Partyholics', 'Swag'][i];
            return FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(110, 48),
              ),
              onPressed: () => onGenre(genre),
              child: Text(genre, style: const TextStyle(fontSize: 12)),
            );
          },
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});
  static final genre = ValueNotifier('Partyholics');
  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  int _year = 2020;
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: TrendingPage.genre,
    builder: (context, genre, _) {
      final tracks = Catalog.tracks
          .skip(1)
          .where((t) => t.genre == genre && t.year == _year)
          .take(5)
          .toList();
      return ListView(
        key: const PageStorageKey('trending-scroll'),
        children: [
          const PageTitle('Trending'),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 38),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _Filter<String>(
                    value: genre,
                    values: const ['Partyholics', 'Pop', 'Hip Hop', 'Swag'],
                    onChanged: (value) => TrendingPage.genre.value = value,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: _Filter<int>(
                    value: _year,
                    values: const [2020, 2019],
                    onChanged: (value) => setState(() => _year = value),
                    accent: true,
                  ),
                ),
                const SizedBox(width: 35),
              ],
            ),
          ),
          const SectionTitle('Trending Songs'),
          if (tracks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'No songs for this selection. Try another genre or year.',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ...tracks.map((t) => TrackTile(t, from: tracks)),
          const SizedBox(height: 18),
          const SectionTitle('Trending Albums'),
          const AlbumRail(
            Catalog.trendingAlbums,
            size: 125,
            showSubtitle: false,
          ),
          const SizedBox(height: 20),
        ],
      );
    },
  );
}

class _Filter<T> extends StatelessWidget {
  const _Filter({
    required this.value,
    required this.values,
    required this.onChanged,
    this.accent = false,
  });
  final T value;
  final List<T> values;
  final ValueChanged<T> onChanged;
  final bool accent;
  @override
  Widget build(BuildContext context) => Container(
    height: 45,
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(
        color: accent ? AppColors.pink : AppColors.pale.withValues(alpha: .7),
      ),
      borderRadius: BorderRadius.circular(5),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
        style: TextStyle(
          fontFamily: 'Poppins',
          color: accent
              ? Theme.of(context).colorScheme.onSurface
              : AppColors.muted,
          fontSize: 13,
        ),
        items: values
            .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    ),
  );
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _favorites = false;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final favoriteTracks = Catalog.tracks
        .where((t) => state.favorites.contains(t.id))
        .toList();
    return ListView(
      key: const PageStorageKey('library-scroll'),
      children: [
        PageTitle(
          'Library',
          action: IconButton(
            key: const ValueKey('library-favorites'),
            tooltip: _favorites ? 'Show albums' : 'Show favorites',
            onPressed: () => setState(() => _favorites = !_favorites),
            icon: Icon(
              _favorites ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: _favorites ? AppColors.pink : AppColors.muted,
            ),
          ),
        ),
        if (_favorites) ...[
          const SectionTitle('Favorite Songs'),
          if (favoriteTracks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Your favorites will appear here. Tap a heart to save a song.',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ...favoriteTracks.map(
            (t) => TrackTile(t, subtitle: t.artist, from: favoriteTracks),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Catalog.albums.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 28,
                childAspectRatio: .77,
              ),
              itemBuilder: (context, i) {
                final album = Catalog.albums[i];
                return InkWell(
                  key: ValueKey('library-album-$i'),
                  onTap: () => openPage(context, AlbumPage(album: album)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Cover(album.cover, width: double.infinity),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        album.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${album.count} Songs',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
