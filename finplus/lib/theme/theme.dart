import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
/// );
class AppTheme {
  // The defined light theme.
  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xff002039),
      primaryContainer: Color(0xff1e3f5a),
      secondary: Color(0xff4e47c6),
      secondaryContainer: Color(0xffcbd5f9),
      tertiary: Color(0xfffab440),
      tertiaryContainer: Color(0xfffbc771),
      appBarColor: Color(0xffcbd5f9),
      error: Color(0xffff4e6e),
      errorContainer: Color(0xffffdad6),
    ),
    surfaceTint: const Color(0xff07143f),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: 'Montserrat', 
  );

  // The defined dark theme.
  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xff9fc9ff),
      primaryContainer: Color(0xff00325b),
      secondary: Color(0xffffb59d),
      secondaryContainer: Color(0xff872100),
      tertiary: Color(0xff86d2e1),
      tertiaryContainer: Color(0xff004e59),
      appBarColor: Color(0xffcbd5f9),
      error: Color(0xffffb4ab),
      errorContainer: Color(0xff93000a),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: 'Montserrat', 
  );
}
