import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/music_widgets.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});
  static String _time(Duration duration) =>
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final favorite = state.favorites.contains(state.current.id);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight, w = constraints.maxWidth;
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: h * .227,
                  child: ContourBackground(height: h * .227),
                ),
                Positioned(
                  top: h * .142,
                  left: 30,
                  child: const Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  top: h * .227 - 15,
                  left: w / 2 - 24,
                  child: IconButton(
                    key: const ValueKey('player-back'),
                    tooltip: 'Close player',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      size: 18,
                      color: AppColors.muted,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  top: h * .316,
                  left: -95,
                  child: Cover('hip', width: 128, height: h * .2, radius: 15),
                ),
                Positioned(
                  top: h * .316,
                  right: -95,
                  child: Cover(
                    'festival',
                    width: 128,
                    height: h * .2,
                    radius: 15,
                  ),
                ),
                Positioned(
                  top: h * .271,
                  left: w * .205,
                  right: w * .205,
                  height: h * .291,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if ((details.primaryVelocity ?? 0).abs() > 100) {
                        state.next(details.primaryVelocity! < 0 ? 1 : -1);
                      }
                    },
                    child: Cover(state.current.cover, radius: 20),
                  ),
                ),
                Positioned(
                  top: h * .583,
                  left: 30,
                  right: 30,
                  child: Column(
                    children: [
                      Text(
                        state.current.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.current.artist,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: h * .65,
                  left: 30,
                  right: 30,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 38,
                        child: Text(
                          _time(state.position),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          key: const ValueKey('playback-progress'),
                          value: state.position.inMilliseconds.toDouble().clamp(
                            0,
                            state.duration.inMilliseconds.toDouble(),
                          ),
                          max: state.duration.inMilliseconds.toDouble(),
                          onChanged: (v) => state.seek(v / 1000),
                        ),
                      ),
                      SizedBox(
                        width: 38,
                        child: Text(
                          _time(state.duration),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: h * .744,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        key: const ValueKey('previous-track'),
                        tooltip: 'Previous track',
                        onPressed: () => state.next(-1),
                        icon: const Icon(
                          CupertinoIcons.backward_end_fill,
                          color: AppColors.pale,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 30),
                      PlayButton(
                        key: const ValueKey('player-play'),
                        onPressed: state.togglePlayback,
                        playing: state.playing,
                        size: 68,
                        color: AppColors.blue,
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        key: const ValueKey('next-track'),
                        tooltip: 'Next track',
                        onPressed: state.next,
                        icon: const Icon(
                          CupertinoIcons.forward_end_fill,
                          color: AppColors.pale,
                          size: 23,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: h * .875,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        key: const ValueKey('player-favorite'),
                        tooltip: 'Favorite',
                        onPressed: () => state.toggleFavorite(state.current),
                        icon: Icon(
                          favorite
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: AppColors.pink,
                          size: 25,
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('shuffle'),
                        tooltip: 'Shuffle',
                        isSelected: state.shuffle,
                        onPressed: state.toggleShuffle,
                        icon: Icon(
                          CupertinoIcons.shuffle,
                          color: state.shuffle
                              ? AppColors.pink
                              : AppColors.pale,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('repeat'),
                        tooltip: 'Repeat one',
                        isSelected: state.repeat,
                        onPressed: state.toggleRepeat,
                        icon: Icon(
                          state.repeat
                              ? CupertinoIcons.repeat_1
                              : CupertinoIcons.repeat,
                          color: state.repeat ? AppColors.pink : AppColors.pale,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('queue'),
                        tooltip: 'Play queue',
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            height: MediaQuery.sizeOf(context).height * .65,
                            child: Column(
                              children: [
                                const SectionTitle('Play Queue'),
                                Expanded(
                                  child: ListView(
                                    children: state.queue
                                        .map(
                                          (t) => ListTile(
                                            leading: Cover(
                                              t.cover,
                                              width: 44,
                                              height: 44,
                                            ),
                                            title: Text(
                                              t.title,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            subtitle: Text(
                                              t.artist,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            trailing: t.id == state.current.id
                                                ? const Icon(
                                                    Icons.graphic_eq,
                                                    color: AppColors.blue,
                                                  )
                                                : null,
                                            onTap: () {
                                              state.playTrack(t);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        icon: const Icon(
                          CupertinoIcons.music_note_list,
                          color: AppColors.pale,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.paddingOf(context).bottom + 2,
                  left: 30,
                  right: 30,
                  child: Text(
                    state.audioError.isEmpty
                        ? 'Original demo audio · Offline preview'
                        : state.audioError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: state.audioError.isEmpty
                          ? AppColors.muted
                          : AppColors.pink,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
