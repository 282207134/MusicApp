import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_state.dart';
import 'core/theme.dart';
import 'features/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(await SharedPreferences.getInstance());
  runApp(MusicApp(state: state));
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: ValueListenableBuilder<bool>(
      valueListenable: state.darkMode,
      builder: (context, dark, _) => MaterialApp(
        title: 'Music Studio',
        debugShowCheckedModeBanner: false,
        theme: AppColors.theme(false),
        darkTheme: AppColors.theme(true),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: child!,
        ),
        home: const AppShell(),
      ),
    ),
  );
}
