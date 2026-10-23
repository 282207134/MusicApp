import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/music_widgets.dart';
import 'browse_pages.dart';
import 'search_page.dart';
import 'settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;
  static const labels = ['Home', 'Trending', 'Search', 'Library', 'Settings'];
  static const icons = [
    CupertinoIcons.house,
    CupertinoIcons.bolt,
    CupertinoIcons.search,
    CupertinoIcons.book,
    CupertinoIcons.slider_horizontal_3,
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: IndexedStack(
        index: _tab,
        children: [
          HomePage(
            onGenre: (genre) {
              setState(() => _tab = 1);
              TrendingPage.genre.value = genre;
            },
          ),
          const TrendingPage(),
          const SearchPage(),
          const LibraryPage(),
          const SettingsPage(),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(withNavigation: true),
          ClipPath(
            clipper: _NavClipper(_tab),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 75,
                  child: Row(
                    children: List.generate(
                      5,
                      (i) => Expanded(
                        child: Semantics(
                          selected: i == _tab,
                          button: true,
                          label: labels[i],
                          child: InkWell(
                            key: ValueKey('nav-$i'),
                            onTap: () => setState(() => _tab = i),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17),
                              child: Column(
                                children: [
                                  Icon(
                                    icons[i],
                                    size: 29,
                                    color: i == _tab
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurface
                                        : AppColors.pale,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    labels[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: i == _tab
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onSurface
                                          : AppColors.pale,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavClipper extends CustomClipper<Path> {
  _NavClipper(this.index);
  final int index;
  @override
  Path getClip(Size size) {
    final x = size.width * (index + .5) / 5;
    return Path()
      ..moveTo(0, 32)
      ..quadraticBezierTo(0, 2, 32, 2)
      ..lineTo(x - 20, 2)
      ..cubicTo(x - 9, 2, x - 10, 15, x, 15)
      ..cubicTo(x + 10, 15, x + 9, 2, x + 20, 2)
      ..lineTo(size.width - 32, 2)
      ..quadraticBezierTo(size.width, 2, size.width, 32)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_NavClipper oldClipper) => index != oldClipper.index;
}
