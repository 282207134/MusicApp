import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../data/catalog.dart';
import '../widgets/music_widgets.dart';
import 'player_page.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key, required this.album});
  final Album album;
  @override
  Widget build(BuildContext context) => _DetailPage(
    title: album.title,
    subtitle: 'Pop Songs',
    cover: album == Catalog.albums.first ? 'album' : album.cover,
    album: album,
  );
}

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key, required this.artist});
  final Artist artist;
  @override
  Widget build(BuildContext context) => _DetailPage(
    title: artist.name,
    subtitle: 'Hey! Here is ${artist.name}, A Pop Singer.',
    cover: artist.cover,
    artist: artist,
  );
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({
    required this.title,
    required this.subtitle,
    required this.cover,
    this.album,
    this.artist,
  });
  final String title, subtitle, cover;
  final Album? album;
  final Artist? artist;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isArtist = artist != null;
    final songs = isArtist ? Catalog.topSongs : Catalog.albumSongs;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 382,
              child: Stack(
                children: [
                  const ContourBackground(height: 327),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top,
                    left: 18,
                    child: IconButton(
                      key: const ValueKey('detail-back'),
                      tooltip: 'Back',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 133,
                    left: 30,
                    right: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFACC8FF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 215,
                    left: 30,
                    child: Cover(cover, width: 135, height: 164, radius: 20),
                  ),
                  Positioned(
                    top: 245,
                    left: 184,
                    right: 25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArtist ? 'Followers' : 'Songs',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFA5C1FF),
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isArtist
                                    ? (state.following.contains(title)
                                          ? '45,784'
                                          : '45,783')
                                    : '${songs.length} Songs',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        if (isArtist)
                          Flexible(
                            child: SizedBox(
                              height: 37,
                              child: OutlinedButton(
                                key: const ValueKey('follow-artist'),
                                onPressed: () => state.toggleFollow(title),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                  ),
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  state.following.contains(title)
                                      ? 'Following'
                                      : 'Follow',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          )
                        else
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Author',
                                  style: TextStyle(
                                    color: Color(0xFFA5C1FF),
                                    fontSize: 10,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Various Artists',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 302,
                    left: 184,
                    child: PlayButton(
                      onPressed: () {
                        state.playTrack(songs.first, from: songs);
                        openPage(context, const PlayerPage());
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            if (isArtist)
              SectionTitle(
                'Top Songs',
                onShowAll: () => openPage(
                  context,
                  TrackListPage(
                    title: '$title · Songs',
                    tracks: Catalog.tracks,
                  ),
                ),
              ),
            ...songs.indexed.map(
              (entry) => TrackTile(
                entry.$2,
                number: isArtist ? null : entry.$1 + 1,
                subtitle: isArtist ? entry.$2.plays : entry.$2.artist,
                from: songs,
              ),
            ),
            if (isArtist) ...[
              const SizedBox(height: 18),
              const SectionTitle('Albums'),
              const AlbumRail([
                Album('Gully Boy 2', 'stage'),
                Album('Gully Boy Unlimited', 'concert'),
                Album('Hip Gully Boy', 'festival'),
              ], showSubtitle: false),
            ],
            const SizedBox(height: 16),
          ],
        ),
        bottomNavigationBar: const DetailDock(),
      ),
    );
  }
}

class TrackListPage extends StatelessWidget {
  const TrackListPage({super.key, required this.title, required this.tracks});
  final String title;
  final List<Track> tracks;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title, style: const TextStyle(fontSize: 18))),
    body: ListView(
      children: tracks.map((t) => TrackTile(t, from: tracks)).toList(),
    ),
    bottomNavigationBar: const DetailDock(),
  );
}
