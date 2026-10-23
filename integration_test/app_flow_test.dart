import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/core/app_state.dart';
import 'package:music_app/data/catalog.dart';
import 'package:music_app/features/browse_pages.dart';
import 'package:music_app/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('all nine screens in both themes and native playback', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    final state = AppState(preferences);
    Future<void> tap(String key) async {
      await tester.tap(find.byKey(ValueKey(key)).first);
      await tester.pumpAndSettle();
    }

    Future<void> shot(String name) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
      expect(tester.takeException(), isNull);
    }

    for (final dark in [false, true]) {
      final theme = dark ? 'dark' : 'light';
      state.setDark(dark);
      state.current = Catalog.tracks.first;
      await tester.pumpWidget(MusicApp(key: ValueKey(theme), state: state));
      await tester.pumpAndSettle();
      await shot('01-home-$theme');
      await tap('nav-1');
      await shot('02-trending-$theme');
      await tap('nav-2');
      await shot('03-search-$theme');
      await tester.enterText(
        find.byKey(const ValueKey('search-input')),
        'Gully Boy',
      );
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await shot('04-search-results-$theme');
      await tap('nav-3');
      await shot('05-library-$theme');
      await tap('library-album-0');
      await shot('06-album-$theme');
      await tap('detail-back');
      await tap('nav-0');
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('artist-sam')),
        300,
        scrollable: find
            .descendant(
              of: find.byType(HomePage),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tap('artist-sam');
      await shot('07-artist-$theme');
      await tap('follow-artist');
      expect(state.following, contains('Sam Smith'));
      await tap('follow-artist');
      await tap('detail-back');
      await tap('mini-player');
      await state.playTrack(Catalog.byId('apna'));
      await tester.pump(const Duration(seconds: 3));
      expect(state.audioError, isEmpty);
      expect(state.playing, isTrue);
      expect(state.position.inMilliseconds, greaterThan(200));
      await state.togglePlayback();
      await state.seek(90);
      await tester.pumpAndSettle();
      await shot('08-player-$theme');
      await tap('player-favorite');
      expect(state.favorites, contains('apna'));
      await tap('player-favorite');
      await tap('shuffle');
      expect(state.shuffle, isTrue);
      await tap('shuffle');
      await tap('repeat');
      expect(state.repeat, isTrue);
      await tap('repeat');
      await tap('queue');
      expect(find.text('Play Queue'), findsOneWidget);
      Navigator.of(tester.element(find.text('Play Queue'))).pop();
      await tester.pumpAndSettle();
      await tap('player-back');
      await tap('nav-4');
      await shot('09-settings-$theme');
      await tap('dark-theme');
      expect(state.dark, !dark);
      await tap('dark-theme');
      expect(state.dark, dark);
    }
    state.setDark(false);
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
