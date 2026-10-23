import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF001B51);
  static const blue = Color(0xFF477EFF);
  static const pink = Color(0xFFFF4A70);
  static const muted = Color(0xFF8191B3);
  static const pale = Color(0xFFB4BED3);
  static ThemeData theme(bool dark) => ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: dark ? navy : Colors.white,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: blue,
          brightness: dark ? Brightness.dark : Brightness.light,
        ).copyWith(
          primary: blue,
          secondary: pink,
          surface: dark ? navy : Colors.white,
          onSurface: dark ? Colors.white : navy,
        ),
    textTheme: ThemeData().textTheme.apply(
      fontFamily: 'Poppins',
      bodyColor: dark ? Colors.white : navy,
      displayColor: dark ? Colors.white : navy,
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: pink,
      thumbColor: pink,
      trackHeight: 3,
      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? pink : const Color(0xFFB9C9EB),
      ),
      trackColor: WidgetStateProperty.all(const Color(0x228191B3)),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbIcon: WidgetStateProperty.all(
        const Icon(Icons.circle, color: Colors.transparent),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: dark ? Colors.white : navy),
    ),
    splashFactory: NoSplash.splashFactory,
  );
}
