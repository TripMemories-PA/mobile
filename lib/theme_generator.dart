import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/my_colors.dart';

class ThemeGenerator {
  static const double kBorderRadius = 10;

  static final Color _borderColor = Colors.grey.shade300;

  static final Color _hintColor = Colors.grey.shade500;

  static CheckboxThemeData get _checkBoxTheme => CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(),
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          },
        ),
      );

  static TextTheme get _textTheme => TextTheme(
    bodyLarge: TextStyle(
      fontFamily: GoogleFonts.urbanist().fontFamily,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: GoogleFonts.urbanist().fontFamily,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  static ColorScheme get _colorScheme => const ColorScheme(
        primary: Color(0xFF4169E1),
        onPrimary: Colors.white,
        secondary: Color(0x1a5569e1),
        onSecondary: Colors.black,
        tertiary: MyColors.lightGrey,
        onTertiary: Colors.black,
        surface: Colors.white,
        onSurface: MyColors.darkGrey,
        brightness: Brightness.light,
        error: Colors.black,
        onError: Colors.white,
        surfaceTint: Color(0xffd4dfff),
      );

  static InputDecorationTheme get _inputDecorationTheme =>
      const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.darkGrey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.only(left: 8.0),
      );

  static TabBarTheme get _tabBarTheme => TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: _colorScheme.primary,
        unselectedLabelColor: _colorScheme.primary,
        labelColor: _colorScheme.primary,
        labelStyle:
            _textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: _textTheme.bodyMedium,
      );

  static FloatingActionButtonThemeData get _floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      );

  static SwitchThemeData get _switchTheme => SwitchThemeData(
        trackColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _colorScheme.primary.withAlpha(100);
          }
          return Colors.grey.withAlpha(100);
        }),
        thumbColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return _colorScheme.primary;
          }
          return Colors.grey;
        }),
      );

  static AppBarTheme get _appBarTheme => AppBarTheme(
        surfaceTintColor: Colors.transparent,
        color: _colorScheme.surface,
        foregroundColor: _colorScheme.onSurface,
        elevation: 0,
      );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          animationDuration: Duration.zero,
          textStyle: WidgetStatePropertyAll<TextStyle>(
            _textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor:
              WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return _colorScheme.tertiary;
            }
            return _colorScheme.primary;
          }),
          shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          shape: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
        ),
      );

  static IconButtonThemeData get _iconButtonTheme => IconButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) => EdgeInsets.zero,
          ),
          iconColor: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) => _colorScheme.surface,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return _colorScheme.tertiary;
              }
              return _colorScheme.primary;
            },
          ),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: ButtonStyle(
          animationDuration: Duration.zero,
          overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          textStyle: WidgetStateProperty.all(
            _textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      );

  static DividerThemeData get _dividerTheme =>
      DividerThemeData(color: _borderColor);

  static CardTheme get _cardTheme => CardTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: _colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _borderColor),
          borderRadius: BorderRadius.circular(14),
        ),
      );

  static DialogTheme get _dialogTheme => DialogTheme(
        backgroundColor: _colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      );

  static ExpansionTileThemeData get _expansionTileTheme =>
      const ExpansionTileThemeData(shape: Border());

  static PopupMenuThemeData get _popupMenuTheme =>
      const PopupMenuThemeData(surfaceTintColor: Colors.transparent);

  static ThemeData generate() => ThemeData(
        useMaterial3: true,
        cardTheme: _cardTheme,
        hintColor: _hintColor,
        dividerTheme: _dividerTheme,
        expansionTileTheme: _expansionTileTheme,
        dividerColor: _borderColor,
        splashColor: Colors.transparent,
        dialogBackgroundColor: _colorScheme.surface,
        dialogTheme: _dialogTheme,
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        checkboxTheme: _checkBoxTheme,
        textButtonTheme: _textButtonTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        iconButtonTheme: _iconButtonTheme,
        appBarTheme: _appBarTheme,
        switchTheme: _switchTheme,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        tabBarTheme: _tabBarTheme,
        popupMenuTheme: _popupMenuTheme,
        inputDecorationTheme: _inputDecorationTheme,
      );
}
