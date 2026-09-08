import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _themeFrom(_lightScheme);

  static ThemeData get dark => _themeFrom(_darkScheme);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFE0952A),
    onPrimary: Color(0xFF241A09),
    primaryContainer: Color(0xFFFFE2B4),
    onPrimaryContainer: Color(0xFF2A1F0C),
    secondary: Color(0xFF7A6A55),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF7DCAC),
    onSecondaryContainer: Color(0xFF2A1F0C),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFFBF8F4),
    onSurface: Color(0xFF1C1917),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F3ED),
    surfaceContainer: Color(0xFFF1ECE4),
    surfaceContainerHigh: Color(0xFFEBE5DC),
    surfaceContainerHighest: Color(0xFFE5DED4),
    onSurfaceVariant: Color(0xFF6D635A),
    outline: Color(0xFFD5CCC1),
    outlineVariant: Color(0xFFE7E0D6),
    inverseSurface: Color(0xFF32302D),
    onInverseSurface: Color(0xFFF5F0E9),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF0B45C),
    onPrimary: Color(0xFF2A1C05),
    primaryContainer: Color(0xFF6A4A12),
    onPrimaryContainer: Color(0xFFFFE2B4),
    secondary: Color(0xFFD6C3A6),
    onSecondary: Color(0xFF392F1F),
    secondaryContainer: Color(0xFF574316),
    onSecondaryContainer: Color(0xFFFFE2B4),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF13110F),
    onSurface: Color(0xFFF3EEE7),
    surfaceContainerLowest: Color(0xFF0D0C0A),
    surfaceContainerLow: Color(0xFF1A1815),
    surfaceContainer: Color(0xFF1F1C19),
    surfaceContainerHigh: Color(0xFF2A2622),
    surfaceContainerHighest: Color(0xFF35302B),
    onSurfaceVariant: Color(0xFFA89E93),
    outline: Color(0xFF534C45),
    outlineVariant: Color(0xFF2E2A26),
    inverseSurface: Color(0xFFF3EEE7),
    onInverseSurface: Color(0xFF32302D),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  static SystemUiOverlayStyle overlayStyleFor(ColorScheme scheme) {
    final dark = scheme.brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: scheme.brightness,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: dark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );
  }

  static ThemeData _themeFrom(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: overlayStyleFor(scheme),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: AppShape.medium,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: AppShape.medium,
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: AppShape.small,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: AppShape.small,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: AppShape.small,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        border: const OutlineInputBorder(
          borderRadius: AppShape.smallRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppShape.smallRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShape.smallRadius,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
