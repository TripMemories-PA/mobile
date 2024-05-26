import 'package:flutter/material.dart';

// ignore_for_file: unused_element, deprecated_member_use,
// deprecated_member_use_from_same_package,
// use_function_type_syntax_for_parameters, unnecessary_const,
// avoid_init_to_null, invalid_override_different_default_values_named,
// prefer_expression_function_bodies, annotate_overrides,
// invalid_annotation_target, unnecessary_question_mark

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
        fillColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Colors.white;
          },
        ),
      );

  static TextTheme get _textTheme => Typography.blackCupertino;

  static ColorScheme get _colorScheme => const ColorScheme(
        background: Colors.white,
        onBackground: Colors.black,
        primary: Color(0xFF4169E1),
        onPrimary: Colors.white,
        secondary: Color(0xfff16f67),
        onSecondary: Colors.white,
        tertiary: Color(0xffffe1cc),
        onTertiary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
        error: Colors.black,
        onError: Colors.white,
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
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return _colorScheme.primary.withAlpha(100);
          }
          return Colors.grey.withAlpha(100);
        }),
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
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
          textStyle: MaterialStatePropertyAll<TextStyle>(
            _textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return _colorScheme.tertiary;
            }
            return _colorScheme.primary;
          }),
          shadowColor:
              const MaterialStatePropertyAll<Color>(Colors.transparent),
          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
          shape: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: ButtonStyle(
          animationDuration: Duration.zero,
          overlayColor:
              const MaterialStatePropertyAll<Color>(Colors.transparent),
          textStyle: MaterialStateProperty.all(
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
        appBarTheme: _appBarTheme,
        switchTheme: _switchTheme,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        tabBarTheme: _tabBarTheme,
        popupMenuTheme: _popupMenuTheme,
      );
}
