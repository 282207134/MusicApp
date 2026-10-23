import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/catalog.dart';

class AppState extends ChangeNotifier {
  AppState(this.preferences, {this.audioEnabled = true}) {
    darkMode = ValueNotifier(preferences.getBool('dark') ?? false);
    favorites.addAll(preferences.getStringList('favorites') ?? []);
    following.addAll(preferences.getStringList('following') ?? []);
    email = preferences.getString('email') ?? 'studio@music.com';
    offline = preferences.getBool('offline') ?? true;
    autoplay = preferences.getBool('autoplay') ?? false;
    normalisation = preferences.getBool('normalisation') ?? true;
    quality = preferences.getDouble('quality') ?? .67;
    if (audioEnabled) {
      _player = AudioPlayer();
      _subscriptions.add(
        _player!.positionStream.listen((value) {
          position = value;
          notifyListeners();
        }),
      );
      _subscriptions.add(
        _player!.playerStateStream.listen((value) {
          playing =
              value.playing &&
              value.processingState != ProcessingState.completed;
          notifyListeners();
          if (value.processingState == ProcessingState.completed &&
              autoplay &&
              !repeat) {
            unawaited(next());
          }
        }),
      );
      _subscriptions.add(
        _player!.errorStream.listen((error) {
          audioError = 'Unable to play demo audio. Please try again.';
          notifyListeners();
        }),
      );
    }
  }
  final SharedPreferences preferences;
  final bool audioEnabled;
  AudioPlayer? _player;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Set<String> favorites = {}, following = {};
  Track current = Catalog.tracks.first;
  late final ValueNotifier<bool> darkMode;
  bool get dark => darkMode.value;
  bool playing = false, shuffle = false, repeat = false;
  bool offline = true, autoplay = false, normalisation = true;
  double quality = .67;
  String email = '', audioError = '';
  Duration position = Duration.zero, duration = const Duration(seconds: 216);
  bool _loaded = false;
  List<Track> queue = List.of(Catalog.tracks);

  Future<void> togglePlayback() async {
    if (!audioEnabled) {
      playing = !playing;
      notifyListeners();
      return;
    }
    try {
      audioError = '';
      if (!_loaded) {
        duration =
            await _player!.setAsset('assets/audio/preview.m4a') ?? duration;
        _loaded = true;
      }
      if (_player!.playing &&
          _player!.processingState != ProcessingState.completed) {
        await _player!.pause();
      } else {
        if (_player!.processingState == ProcessingState.completed) {
          await _player!.seek(Duration.zero);
        }
        unawaited(
          _player!.play().catchError((Object e) {
            audioError = 'Unable to play demo audio.';
            notifyListeners();
          }),
        );
      }
    } catch (_) {
      audioError = 'Unable to load demo audio. Please try again.';
      notifyListeners();
    }
  }

  Future<void> playTrack(Track track, {List<Track>? from}) async {
    current = track;
    if (from != null && from.isNotEmpty) {
      queue = List.of(from);
    }
    if (!queue.any((t) => t.id == track.id)) {
      queue = List.of(Catalog.tracks);
    }
    position = Duration.zero;
    if (_loaded) {
      await _player?.seek(Duration.zero);
    }
    if (!playing) {
      await togglePlayback();
    }
    notifyListeners();
  }

  Future<void> next([int step = 1]) async {
    final index = queue.indexWhere((t) => t.id == current.id);
    final nextIndex = shuffle && queue.length > 1
        ? (index + 1 + Random().nextInt(queue.length - 1)) % queue.length
        : (index + step) % queue.length;
    await playTrack(queue[nextIndex]);
  }

  Future<void> seek(double seconds) async {
    position = Duration(milliseconds: (seconds * 1000).round());
    if (_loaded) {
      await _player?.seek(position);
    }
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    repeat = !repeat;
    await _player?.setLoopMode(repeat ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  void toggleFavorite(Track track) {
    favorites.contains(track.id)
        ? favorites.remove(track.id)
        : favorites.add(track.id);
    unawaited(preferences.setStringList('favorites', favorites.toList()));
    notifyListeners();
  }

  void toggleFollow(String name) {
    following.contains(name) ? following.remove(name) : following.add(name);
    unawaited(preferences.setStringList('following', following.toList()));
    notifyListeners();
  }

  void setDark(bool value) {
    darkMode.value = value;
    unawaited(preferences.setBool('dark', value));
    notifyListeners();
  }

  void setPreference(String key, bool value) {
    switch (key) {
      case 'offline':
        offline = value;
      case 'autoplay':
        autoplay = value;
      case 'normalisation':
        normalisation = value;
    }
    unawaited(preferences.setBool(key, value));
    notifyListeners();
  }

  void setQuality(double value) {
    quality = value;
    unawaited(preferences.setDouble('quality', value));
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    unawaited(preferences.setString('email', value));
    notifyListeners();
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    unawaited(_player?.dispose());
    darkMode.dispose();
    super.dispose();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
