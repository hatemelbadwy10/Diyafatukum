import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../extensions/all_extensions.dart' hide ThemeExtension;
import 'custom_color_scheme.dart';
import 'theme_manager.dart';

// Define your light theme colors
class LightThemeColors {
  const LightThemeColors._();
  static const int _primaryValue = 0xFFAD2388;
  static const MaterialColor primary = MaterialColor(_primaryValue, <int, Color>{
    50: Color(0xFFFCE4F6),
    100: Color(0xFFF8C4E8),
    200: Color(0xFFF098D5),
    300: Color(0xFFE86CC2),
    400: Color(0xFFE040AF),
    500: Color(0xFFD81B9C),
    600: Color(0xFFCC0E88),
    700: Color(_primaryValue),
    800: Color(0xFF8B1C6B),
    900: Color(0xFF6A154F),
    950: Color(0xFF490E33),
  });

  static const int _secondaryValue = 0xFF6E126A;
  static const MaterialColor secondary = MaterialColor(_secondaryValue, <int, Color>{
    50: Color(0xFFFAE8F8),
    100: Color(0xFFF3C7EE),
    200: Color(0xFFE895DD),
    300: Color(0xFFDC63CC),
    400: Color(0xFFD031BB),
    500: Color(0xFFB81CA0),
    600: Color(0xFF9B1685),
    700: Color(_secondaryValue),
    800: Color(0xFF560F54),
    900: Color(0xFF3F0B3E),
    950: Color(0xFF280729),
  });

  static const int _tertiaryValue = 0xFF361872;
  static const MaterialColor tertiary = MaterialColor(_tertiaryValue, <int, Color>{
    50: Color(0xFFEDE5F3),
    100: Color(0xFFD4C0E3),
    200: Color(0xFFB898D0),
    300: Color(0xFF9C70BD),
    400: Color(0xFF8048AA),
    500: Color(0xFF6B3B97),
    600: Color(0xFF5A2F84),
    700: Color(0xFF4A2371),
    800: Color(_tertiaryValue),
    900: Color(0xFF28125A),
    950: Color(0xFF1A0C42),
  });

  static const int _accentValue = 0xFF7A41DC;
  static const MaterialColor accent = MaterialColor(_accentValue, <int, Color>{
    50: Color(0xFFF0EBFF),
    100: Color(0xFFDDCCFF),
    200: Color(0xFFBB99FF),
    300: Color(0xFF9966FF),
    400: Color(0xFF8855EE),
    500: Color(_accentValue),
    600: Color(0xFF6633CC),
    700: Color(0xFF5522BB),
    800: Color(0xFF4411AA),
    900: Color(0xFF330088),
    950: Color(0xFF220066),
  });

  static const int _greyValue = 0xFF474747;
  static const MaterialColor grey = MaterialColor(_greyValue, <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFF7F7F8),
    300: Color(0xFFEEEEEE),
    400: Color(0xFFCCCCCC),
    500: Color(0xFFA3A3A3),
    600: Color(0xFF666666),
    700: Color(_greyValue),
    800: Color(0xFF292929),
    900: Color(0xFF121212),
    950: Color(0xFF040504),
  });

  static const int _primaryVariantValue = 0xFF3A70E2;
  static const MaterialColor primaryVariant = MaterialColor(_primaryVariantValue, <int, Color>{
    100: Color(0xFFE4F2FF),
    500: Color(_primaryVariantValue),
  });

  static const Color onPrimary = Colors.white;
  static Color onSecondary = grey[50]!;
  static Color onTertiary = grey[100]!;

  // Validation Colors:
  static const int _errorValue = 0xFFEC2D30;
  static const MaterialColor error = MaterialColor(_errorValue, <int, Color>{
    50: Color(0XFFFFEBEE),
    100: Color(0XFFFFCCD2),
    200: Color(0XFFF49898),
    300: Color(0xFFEB6F70),
    400: Color(0xFFF64C4C),
    500: Color(_errorValue),
  });

  static const int _warningValue = 0xFFFE9B0E;
  static const MaterialColor warning = MaterialColor(_warningValue, <int, Color>{
    50: Color(0xFFFFF7E1),
    100: Color(0xFFFFEAB3),
    200: Color(0xFFFFDD82),
    300: Color(0xFFFFC62B),
    400: Color(0xFFFFAD0D),
    500: Color(_warningValue),
  });

  static const int _successValue = 0xFF0C9D61;
  static const MaterialColor success = MaterialColor(_successValue, <int, Color>{
    50: Color(0xFFE5F5EC),
    100: Color(0xFFC0E5D1),
    200: Color(0xFF97D4B4),
    300: Color(0xFF6BC497),
    400: Color(0xFF47B881),
    500: Color(_successValue),
  });

  // Surface Colors
  static Color primaryContainer = primary[50]!;
  static Color secondaryContainer = secondary[50]!;
  static Color tertiaryContainer = tertiary[50]!;
  static Color accentContainer = accent[50]!;

  static Color disabledContainer = grey[400]!;
  static Color disabledButton = grey[400]!;

  static Color primaryCard = grey[50]!;
  static Color secondaryCard = grey[100]!;

  // Background Color
  static const Color background = Color(0xFFFCFDFF);
  static const Color scaffoldBackground = Color(0xFFFCFDFF);
  static const Color bottomSheetBackground = Color(0xFFFCFDFF);
  static const Color dialogBackground = Color(0xFFFCFDFF);
  static const Color appBarBackground = Color(0xFFFCFDFF);

  // Text Colors
  static Color hintText = grey[600]!;
  static Color unselectedLabel = grey[500]!; // Unselected label color for tabs
  static Color selectedLabel = primary[500]!; // Selected label color for tabs

  // Icons Colors
  static Color selectedIcon = primary;
  static Color unselectedIcon = grey[500]!;
  static Color onBackgroundIcon = grey[950]!;

  // border Colors
  static Color primaryBorderColor = primary[100]!;
  static Color primaryDividerColor = grey[100]!;
  static Color secondaryDividerColor = grey[200]!;
  static Color inputFieldBorder = grey[400]!;

  // shadow
  static Color shadowBottomSheet = Color(0xFF07041A).withValues(alpha: 0.09);
  static Color shadow = Colors.black.withValues(alpha: .04);

  static List<Color> primaryGradient = [tertiary[700]!, primary[600]!, primary];
  static List<Color> secondaryGradient = [accent, secondary];
  static List<Color> tertiaryGradient = [tertiary, primary];
  static List<Color> disabledGradient = [grey[200]!, grey[300]!, grey[400]!];

  // primary gradient with pressed state
  static List<Color> primaryGradientPressed = [tertiary[600]!, primary[600]!, primary[900]!];
}

class LightTheme {
  static ThemeData getTheme() {
    AppThemeManager.setStatusBarAndNavigationBarColors(ThemeMode.light);
    return ThemeData(
      //* Light Theme
      useMaterial3: true,
      fontFamily: FontConstants.fontFamily,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: LightThemeColors.secondaryCard,
      //* Card Theme *//
      primaryColor: LightThemeColors.primary,
      primarySwatch: LightThemeColors.primary,
      scaffoldBackgroundColor: LightThemeColors.scaffoldBackground,

      extensions: <ThemeExtension<dynamic>>[
        CustomColorScheme(
          primarySwatch: LightThemeColors.primary,
          primaryVariantSwatch: LightThemeColors.primaryVariant,
          secondarySwatch: LightThemeColors.secondary,
          tertiarySwatch: LightThemeColors.tertiary,
          accentSwatch: LightThemeColors.accent,
          greySwatch: LightThemeColors.grey,
          errorSwatch: LightThemeColors.error,
          successSwatch: LightThemeColors.success,
          warningSwatch: LightThemeColors.warning,
        ),
      ],

      //* Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: LightThemeColors.primary,
        surfaceTint: Color(0xff4f5e80),
        onPrimary: LightThemeColors.onPrimary,
        primaryContainer: LightThemeColors.primaryContainer,
        onPrimaryContainer: Color(0xff7786aa),
        secondary: LightThemeColors.secondary,
        onSecondary: LightThemeColors.onSecondary,
        secondaryContainer: LightThemeColors.secondaryContainer,
        onSecondaryContainer: Color(0xfffffbff),
        tertiary: LightThemeColors.tertiary,
        onTertiary: LightThemeColors.onTertiary,
        tertiaryContainer: LightThemeColors.tertiaryContainer,
        onTertiaryContainer: Color(0xff007272),
        error: LightThemeColors.error,
        onError: Color(0xffffffff),
        errorContainer: LightThemeColors.error.shade100,
        onErrorContainer: Color(0xfffff6f5),
        surface: LightThemeColors.background,
        onSurface: LightThemeColors.grey[950]!,
        onSurfaceVariant: LightThemeColors.grey[800]!,
        outline: LightThemeColors.grey[400]!,
        outlineVariant: LightThemeColors.grey[300]!,
        shadow: LightThemeColors.shadow,
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff313030),
        inversePrimary: Color(0xffb7c6ed),
        primaryFixed: Color(0xffd8e2ff),
        onPrimaryFixed: Color(0xff091b39),
        primaryFixedDim: Color(0xffb7c6ed),
        onPrimaryFixedVariant: Color(0xff374767),
        secondaryFixed: Color(0xffffd9e4),
        onSecondaryFixed: Color(0xff3e0021),
        secondaryFixedDim: Color(0xffffb0cc),
        onSecondaryFixedVariant: Color(0xff8d0051),
        tertiaryFixed: Color(0xff00fbfb),
        onTertiaryFixed: Color(0xff002020),
        tertiaryFixedDim: Color(0xff00dddd),
        onTertiaryFixedVariant: Color(0xff004f4f),
        surfaceDim: Color(0xffddd9d9),
        surfaceBright: Color(0xfffcf8f8),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff6f3f2),
        surfaceContainer: Color(0xfff1edec),
        surfaceContainerHigh: Color(0xffebe7e7),
        // surfaceContainerHighest: Color(0xffe5e2e1),
      ),
      cardTheme: CardThemeData(elevation: 1, color: LightThemeColors.primaryCard, shadowColor: LightThemeColors.shadow),

      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: LightThemeColors.primary,
          onPrimary: LightThemeColors.onPrimary,
          secondary: LightThemeColors.secondary,
          onSecondary: LightThemeColors.onSecondary,
          surface: LightThemeColors.background,
          onSurface: LightThemeColors.grey[950]!,
          error: LightThemeColors.error,
          onError: Color.fromARGB(255, 112, 17, 17),
        ),
        buttonColor: LightThemeColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),

      //* App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: LightThemeColors.appBarBackground,
        titleTextStyle: TextStylesManager.font.s20.bold.setColor(LightThemeColors.onPrimary),
        iconTheme: IconThemeData(color: LightThemeColors.onBackgroundIcon),
      ),

      //* Text Theme
      textTheme: TextTheme(
        // Display
        displayLarge: TextStylesManager.font.copyWith(color: LightThemeColors.primary),
        displayMedium: TextStylesManager.font.copyWith(color: LightThemeColors.secondary),
        displaySmall: TextStylesManager.font.copyWith(color: LightThemeColors.tertiary),

        // Header
        headlineLarge: TextStylesManager.font.copyWith(color: LightThemeColors.error),
        headlineMedium: TextStylesManager.font.copyWith(color: LightThemeColors.warning),
        headlineSmall: TextStylesManager.font.copyWith(color: LightThemeColors.success),

        // Title
        titleLarge: TextStylesManager.font.copyWith(color: LightThemeColors.grey[950]),
        titleMedium: TextStylesManager.font.copyWith(color: LightThemeColors.grey[900]),
        titleSmall: TextStylesManager.font.copyWith(color: LightThemeColors.grey[800]),

        // Body
        bodyLarge: TextStylesManager.font.copyWith(color: LightThemeColors.grey[700]),
        bodyMedium: TextStylesManager.font.copyWith(color: LightThemeColors.grey[600]),
        bodySmall: TextStylesManager.font.copyWith(color: LightThemeColors.grey[500]),

        // label
        labelLarge: TextStylesManager.font.copyWith(color: LightThemeColors.grey[400]),
        labelMedium: TextStylesManager.font.copyWith(color: LightThemeColors.grey[300]),
        labelSmall: TextStylesManager.font.copyWith(color: LightThemeColors.onPrimary),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: LightThemeColors.onBackgroundIcon),

      splashFactory: InkRipple.splashFactory,

      //*  bottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStylesManager.font.medium.s12.setColor(LightThemeColors.primary),
        unselectedLabelStyle: TextStylesManager.font.medium.s12.setColor(LightThemeColors.unselectedIcon),
        backgroundColor: LightThemeColors.scaffoldBackground,
        selectedItemColor: LightThemeColors.primary,
        unselectedItemColor: LightThemeColors.unselectedIcon,
      ),

      //* Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        dragHandleSize: const Size(72, 4),
        dragHandleColor: LightThemeColors.inputFieldBorder,
        backgroundColor: LightThemeColors.bottomSheetBackground,
        elevation: 0,
      ),

      //* Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: LightThemeColors.primary,
        labelPadding: 0.edgeInsetsAll,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: InkRipple.splashFactory,
        dividerColor: LightThemeColors.grey.shade100,
        unselectedLabelColor: LightThemeColors.unselectedIcon,
        labelStyle: TextStylesManager.font.s12.regular.setColor(LightThemeColors.primary[950]!),
        unselectedLabelStyle: TextStylesManager.font.s12.regular.setColor(LightThemeColors.grey.shade500),
      ),

      //* ElevatedButtonThemeData
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppThemeManager.elevatedButtonStyleTheme(
          buttonColor: LightThemeColors.primary[600]!,
          textColor: LightThemeColors.onPrimary,
        ),
      ),

      //* TextButtonThemeData
      textButtonTheme: TextButtonThemeData(
        style: AppThemeManager.textButtonStyleTheme(textColor: LightThemeColors.primary),
      ),

      //* dividerTheme
      dividerColor: LightThemeColors.secondaryDividerColor,
      dividerTheme: DividerThemeData(thickness: 1, color: LightThemeColors.primaryDividerColor),

      expansionTileTheme: ExpansionTileThemeData(
        iconColor: LightThemeColors.onBackgroundIcon,
        textColor: LightThemeColors.grey,
      ),

      // date picker theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: LightThemeColors.background,
        dayStyle: TextStylesManager.font.regular.s14.setColor(LightThemeColors.grey),
        yearStyle: TextStylesManager.font.regular.s14.setColor(LightThemeColors.grey),
      ),

      // time picker theme
      timePickerTheme: TimePickerThemeData(
        backgroundColor: LightThemeColors.background,
        timeSelectorSeparatorColor: WidgetStateProperty.all(LightThemeColors.primary),
        hourMinuteTextColor: LightThemeColors.grey,
        dialBackgroundColor: LightThemeColors.background,
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: LightThemeColors.inputFieldBorder, width: 1),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: LightThemeColors.inputFieldBorder, width: 1),
        ),
      ),

      //* Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStylesManager.font.s12.ellipsis.setColor(LightThemeColors.hintText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide(color: LightThemeColors.inputFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: LightThemeColors.background,
      ),
    );
  }
}
