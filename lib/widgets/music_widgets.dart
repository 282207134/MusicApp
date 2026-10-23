import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../features/detail_pages.dart';
import '../features/player_page.dart';

void openPage(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

class Cover extends StatelessWidget {
  const Cover(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.radius = 10,
    this.child,
  });
  final String name;
  final double? width, height;
  final double radius;
  final Widget? child;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/$name.jpg', fit: BoxFit.cover),
          ?child,
        ],
      ),
    ),
  );
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(30, 8, 22, 28),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 29.6, fontWeight: FontWeight.w700),
          ),
        ),
        ?action,
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onShowAll});
  final String title;
  final VoidCallback? onShowAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 21.6, fontWeight: FontWeight.w500),
          ),
        ),
        if (onShowAll != null)
          InkWell(
            onTap: onShowAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Show All',
                style: TextStyle(color: AppColors.pink, fontSize: 14),
              ),
            ),
          ),
      ],
    ),
  );
}

class AlbumRail extends StatelessWidget {
  const AlbumRail(
    this.albums, {
    super.key,
    this.size = 150,
    this.showSubtitle = true,
  });
  final List<Album> albums;
  final double size;
  final bool showSubtitle;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: size + (showSubtitle ? 62 : 40),
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      scrollDirection: Axis.horizontal,
      itemCount: albums.length,
      separatorBuilder: (_, _) => const SizedBox(width: 15),
      itemBuilder: (context, i) {
        final album = albums[i];
        return SizedBox(
          width: size,
          child: InkWell(
            key: ValueKey('album-${album.cover}'),
            borderRadius: BorderRadius.circular(10),
            onTap: () => openPage(context, AlbumPage(album: album)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Cover(album.cover, width: size, height: size),
                const SizedBox(height: 6),
                Text(
                  album.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (showSubtitle)
                  Text(
                    album.subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11.6,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class ArtistRail extends StatelessWidget {
  const ArtistRail({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 164,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      scrollDirection: Axis.horizontal,
      itemCount: Catalog.artists.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, i) {
        final artist = Catalog.artists[i];
        return InkWell(
          key: ValueKey('artist-${artist.cover}'),
          onTap: () => openPage(context, ArtistPage(artist: artist)),
          child: SizedBox(
            width: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Cover(artist.cover, width: 125, height: 125),
                const SizedBox(height: 6),
                Text(
                  artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class TrackTile extends StatelessWidget {
  const TrackTile(
    this.track, {
    super.key,
    this.subtitle,
    this.number,
    this.from,
  });
  final Track track;
  final String? subtitle;
  final int? number;
  final List<Track>? from;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final active = state.current.id == track.id;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 18, 14),
      child: InkWell(
        key: ValueKey('track-${track.id}'),
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          state.playTrack(track, from: from);
          openPage(context, const PlayerPage());
        },
        child: Row(
          children: [
            if (number != null)
              SizedBox(
                width: 46,
                child: Text(
                  '${number.toString().padLeft(2, '0')}.',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.blue : Colors.grey.shade400,
                  ),
                ),
              )
            else
              Cover(
                track.cover,
                width: 50,
                height: 50,
                radius: 8,
                child: const Center(
                  child: Icon(
                    CupertinoIcons.play,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            if (number == null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      color: active && number != null ? AppColors.blue : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle ?? track.plays,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'More about ${track.title}',
              icon: const Icon(Icons.more_horiz, color: Color(0xFFBFBFBF)),
              onPressed: () => showTrackActions(context, track),
            ),
          ],
        ),
      ),
    );
  }
}

void showTrackActions(BuildContext context, Track track) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final state = AppScope.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Cover(track.cover, width: 48, height: 48),
                title: Text(track.title),
                subtitle: Text(track.artist),
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.play),
                title: const Text('Play demo audio'),
                onTap: () {
                  state.playTrack(track);
                  Navigator.pop(context);
                  openPage(context, const PlayerPage());
                },
              ),
              ListTile(
                leading: Icon(
                  state.favorites.contains(track.id)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                ),
                title: Text(
                  state.favorites.contains(track.id)
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                ),
                onTap: () {
                  state.toggleFavorite(track);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.onPressed,
    this.playing = false,
    this.size = 48,
    this.color = AppColors.pink,
  });
  final VoidCallback onPressed;
  final bool playing;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: IconButton.filled(
      tooltip: playing ? 'Pause' : 'Play',
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      icon: Icon(
        playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
        size: size * .55,
      ),
    ),
  );
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key, this.withNavigation = false});
  final bool withNavigation;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Semantics(
      label: 'Mini player',
      child: InkWell(
        key: const ValueKey('mini-player'),
        onTap: () => openPage(context, const PlayerPage()),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 25, 24, withNavigation ? 23 : 25),
          child: Row(
            children: [
              Cover(state.current.cover, width: 60, height: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.current.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      state.current.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFC4D5FF),
                        fontSize: 11.6,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const ValueKey('mini-favorite'),
                tooltip: 'Favorite',
                onPressed: () => state.toggleFavorite(state.current),
                icon: Icon(
                  state.favorites.contains(state.current.id)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  key: const ValueKey('mini-play'),
                  tooltip: state.playing ? 'Pause' : 'Play',
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: state.togglePlayback,
                  icon: Icon(
                    state.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailDock extends StatelessWidget {
  const DetailDock({super.key});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: AppColors.blue,
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    child: SafeArea(top: false, child: const MiniPlayer()),
  );
}

class ContourBackground extends StatelessWidget {
  const ContourBackground({super.key, this.height = 315});
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _ContourPainter()),
    ),
  );
}

class _ContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(AppColors.blue, BlendMode.src);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (var j = 0; j < 15; j++) {
      final path = Path();
      for (var i = 0; i <= 200; i++) {
        final angle = i / 200 * pi * 2, radius = 30 + j * 25.0;
        final wave = sin(angle * 7 + j * .3) * (6 + j * .5);
        final x = size.width * .67 + cos(angle) * (radius + wave),
            y = size.height * .8 + sin(angle) * (radius + wave) * .8;
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(path..close(), paint);
    }
  }

  @override
  bool shouldRepaint(_ContourPainter oldDelegate) => false;
}
