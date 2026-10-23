import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/core/app_state.dart';
import 'package:music_app/data/catalog.dart';
import 'package:music_app/main.dart';
import 'package:music_app/widgets/music_widgets.dart';

Future<AppState> testState() async {
  SharedPreferences.setMockInitialValues({});
  return AppState(await SharedPreferences.getInstance(), audioEnabled: false);
}

void main() {
  test('search handles casing, artist, album keywords and empty results', () {
    expect(Catalog.search('  GULLY BOY ').length, 6);
    expect(Catalog.search('Arijit').single.id, 'apna');
    expect(Catalog.search('no such song'), isEmpty);
    expect(Catalog.search('  '), isEmpty);
  });
  test('favorites, follows and theme survive state recreation', () async {
    final state = await testState();
    state.setDark(true);
    state.toggleFavorite(Catalog.tracks.first);
    state.toggleFollow('Sam Smith');
    state.setEmail('demo@example.com');
    final restored = AppState(
      await SharedPreferences.getInstance(),
      audioEnabled: false,
    );
    expect(restored.dark, isTrue);
    expect(restored.favorites, contains('weapon'));
    expect(restored.following, contains('Sam Smith'));
    expect(restored.email, 'demo@example.com');
    state.dispose();
    restored.dispose();
  });
  test(
    'queue wraps, shuffle changes track and controls update state',
    () async {
      final state = await testState();
      await state.playTrack(
        Catalog.tracks.first,
        from: Catalog.tracks.take(3).toList(),
      );
      await state.next(-1);
      expect(state.current.id, 'forget');
      await state.next();
      expect(state.current.id, 'weapon');
      state.toggleShuffle();
      await state.next();
      expect(state.current.id, isNot('weapon'));
      await state.seek(42);
      expect(state.position.inSeconds, 42);
      await state.toggleRepeat();
      expect(state.repeat, isTrue);
      await state.togglePlayback();
      expect(state.playing, isFalse);
      state.dispose();
    },
  );
  testWidgets('search, player, favorite library and dark theme work together', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = await testState();
    await tester.pumpWidget(MusicApp(state: state));
    await tester.pumpAndSettle();
    expect(find.text('Explore'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('nav-2')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('search-input')),
      'nonesuch',
    );
    await tester.pumpAndSettle();
    expect(find.text('No results found'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('search-input')),
      'Gully Boy',
    );
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('track-gully')).first);
    await tester.pumpAndSettle();
    expect(find.text('Now Playing'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('player-favorite')));
    await tester.pumpAndSettle();
    expect(state.favorites, contains('gully'));
    await tester.tap(find.byKey(const ValueKey('player-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('library-favorites')));
    await tester.pumpAndSettle();
    expect(find.text('Favorite Songs'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('nav-4')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('dark-theme')));
    await tester.tap(find.byKey(const ValueKey('dark-theme')));
    await tester.pumpAndSettle();
    expect(state.dark, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
  testWidgets('compact viewport keeps main navigation and player usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = await testState();
    await tester.pumpWidget(MusicApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('library-album-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('detail-back')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('mini-player'))).dy,
      greaterThan(400),
    );
    await tester.tap(find.byKey(const ValueKey('detail-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('mini-player')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('player-play')), findsOneWidget);
    expect(
      tester.getSize(find.byType(ContourBackground)).height,
      lessThan(170),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
