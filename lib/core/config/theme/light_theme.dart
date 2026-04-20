import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../extensions/all_extensions.dart' hide ThemeExtension;
import 'custom_color_scheme.dart';
import 'theme_manager.dart';

// Define your light theme colors
class LightThemeColors {
  const LightThemeColors._();
  static const int _primaryValue = 0xFFCF9D29;
  static const MaterialColor primary = MaterialColor(_primaryValue, <int, Color>{
    50: Color(0xFFFFF8E8),
    100: Color(0xFFF8E9BE),
    200: Color(0xFFF0D78E),
    300: Color(0xFFE7C45D),
    400: Color(0xFFDDB23B),
    500: Color(_primaryValue),
    600: Color(0xFFB88922),
    700: Color(0xFFA2711B),
    800: Color(0xFF875E15),
    900: Color(0xFF6B4A10),
    950: Color(0xFF523708),
  });

  static const int _secondaryValue = 0xFFC2A279;
  static const MaterialColor secondary = MaterialColor(_secondaryValue, <int, Color>{
    50: Color(0xFFF8F3EC),
    100: Color(0xFFEEE4D6),
    200: Color(0xFFE3D2BC),
    300: Color(0xFFD7BEA0),
    400: Color(0xFFCCAE8B),
    500: Color(_secondaryValue),
    600: Color(0xFFAC8D66),
    700: Color(0xFF96754E),
    800: Color(0xFF7D6140),
    900: Color(0xFF654D34),
    950: Color(0xFF49361F),
  });

  static const int _tertiaryValue = 0xFF7A5E15;
  static const MaterialColor tertiary = MaterialColor(_tertiaryValue, <int, Color>{
    50: Color(0xFFFAF4E4),
    100: Color(0xFFF1E4B8),
    200: Color(0xFFE6D188),
    300: Color(0xFFD8BD57),
    400: Color(0xFFCCA731),
    500: Color(0xFFB98E1D),
    600: Color(0xFF9F7918),
    700: Color(0xFF886614),
    800: Color(_tertiaryValue),
    900: Color(0xFF5F4910),
    950: Color(0xFF46340A),
  });

  static const int _accentValue = 0xFF7A5E15;
  static const MaterialColor accent = MaterialColor(_accentValue, <int, Color>{
    50: Color(0xFFF7F1E1),
    100: Color(0xFFE8D8AF),
    200: Color(0xFFD6BC75),
    300: Color(0xFFC4A246),
    400: Color(0xFFAF891F),
    500: Color(_accentValue),
    600: Color(0xFF664F12),
    700: Color(0xFF574310),
    800: Color(0xFF48370D),
    900: Color(0xFF392B0A),
    950: Color(0xFF281D06),
  });

  static const int _greyValue = 0xFF666666;
  static const MaterialColor grey = MaterialColor(_greyValue, <int, Color>{
    50: Color(0xFFF8F8F8),
    100: Color(0xFFEEEEEE),
    200: Color(0xFFD6D6D6),
    300: Color(0xFFA5A5A5),
    400: Color(0xFF8A8A8A),
    500: Color(0xFF4A4A4A),
    600: Color(_greyValue),
    700: Color(0xFF333333),
    800: Color(0xFF252525),
    900: Color(0xFF1D1F1F),
    950: Color(0xFF101111),
  });

  static const int _primaryVariantValue = 0xFFC2A279;
  static const MaterialColor primaryVariant = MaterialColor(_primaryVariantValue, <int, Color>{
    100: Color(0xFFF8F3EC),
    500: Color(_primaryVariantValue),
  });

  static const Color onPrimary = Colors.white;
  static Color onSecondary = grey[50]!;
  static Color onTertiary = grey[100]!;

  // Validation Colors:
  static const int _errorValue = 0xFFF55157;
  static const MaterialColor error = MaterialColor(_errorValue, <int, Color>{
    50: Color(0xFFFFECEE),
    100: Color(0xFFFFD3D6),
    200: Color(0xFFFFB0B4),
    300: Color(0xFFFF8D92),
    400: Color(0xFFFF6F75),
    500: Color(_errorValue),
  });

  static const int _warningValue = 0xFFFFB74A;
  static const MaterialColor warning = MaterialColor(_warningValue, <int, Color>{
    50: Color(0xFFFFF4E2),
    100: Color(0xFFFFE3B8),
    200: Color(0xFFFFD089),
    300: Color(0xFFFFC15D),
    400: Color(0xFFFFB84C),
    500: Color(_warningValue),
  });

  static const int _successValue = 0xFF50AF6C;
  static const MaterialColor success = MaterialColor(_successValue, <int, Color>{
    50: Color(0xFFE8F5EC),
    100: Color(0xFFC3E5CD),
    200: Color(0xFF9CD6AD),
    300: Color(0xFF74C68D),
    400: Color(0xFF59BA76),
    500: Color(_successValue),
  });

  // Surface Colors
  static Color primaryContainer = primary[50]!;
  static Color secondaryContainer = secondary[50]!;
  static Color tertiaryContainer = tertiary[50]!;
  static Color accentContainer = accent[50]!;

  static Color disabledContainer = grey[200]!;
  static Color disabledButton = grey[300]!;

  static Color primaryCard = grey[50]!;
  static Color secondaryCard = grey[100]!;

  // Background Color
  static const Color background = Colors.white;
  static const Color scaffoldBackground = Colors.white;
  static const Color bottomSheetBackground = Colors.white;
  static const Color dialogBackground = Colors.white;
  static const Color appBarBackground = Colors.white;

  // Text Colors
  static Color hintText = grey[300]!;
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
  static Color inputFieldBorder = grey[200]!;

  // shadow
  static Color shadowBottomSheet = Color(0xFF07041A).withValues(alpha: 0.09);
  static Color shadow = Colors.black.withValues(alpha: .04);

  static List<Color> primaryGradient = [primary, const Color(0xFF694F15)];
  static List<Color> secondaryGradient = [secondary, primary];
  static List<Color> tertiaryGradient = [accent, primary];
  static List<Color> disabledGradient = [grey[200]!, grey[300]!, grey[400]!];

  // primary gradient with pressed state
  static List<Color> primaryGradientPressed = [primary[300]!, primary[500]!, primary[800]!];
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
        surfaceTint: LightThemeColors.primary,
        onPrimary: LightThemeColors.onPrimary,
        primaryContainer: LightThemeColors.primaryContainer,
        onPrimaryContainer: LightThemeColors.primary.shade900,
        secondary: LightThemeColors.secondary,
        onSecondary: LightThemeColors.onSecondary,
        secondaryContainer: LightThemeColors.secondaryContainer,
        onSecondaryContainer: LightThemeColors.secondary.shade900,
        tertiary: LightThemeColors.tertiary,
        onTertiary: LightThemeColors.onTertiary,
        tertiaryContainer: LightThemeColors.tertiaryContainer,
        onTertiaryContainer: LightThemeColors.tertiary.shade900,
        error: LightThemeColors.error,
        onError: Colors.white,
        errorContainer: LightThemeColors.error.shade100,
        onErrorContainer: LightThemeColors.error.shade500,
        surface: LightThemeColors.background,
        onSurface: LightThemeColors.grey[950]!,
        onSurfaceVariant: LightThemeColors.grey[800]!,
        outline: LightThemeColors.grey[400]!,
        outlineVariant: LightThemeColors.grey[300]!,
        shadow: LightThemeColors.shadow,
        scrim: Colors.black,
        inverseSurface: LightThemeColors.grey[900]!,
        inversePrimary: LightThemeColors.primary.shade200,
        primaryFixed: LightThemeColors.primary.shade100,
        onPrimaryFixed: LightThemeColors.primary.shade900,
        primaryFixedDim: LightThemeColors.primary.shade200,
        onPrimaryFixedVariant: LightThemeColors.primary.shade700,
        secondaryFixed: LightThemeColors.secondary.shade100,
        onSecondaryFixed: LightThemeColors.secondary.shade900,
        secondaryFixedDim: LightThemeColors.secondary.shade200,
        onSecondaryFixedVariant: LightThemeColors.secondary.shade700,
        tertiaryFixed: LightThemeColors.tertiary.shade100,
        onTertiaryFixed: LightThemeColors.tertiary.shade900,
        tertiaryFixedDim: LightThemeColors.tertiary.shade200,
        onTertiaryFixedVariant: LightThemeColors.tertiary.shade700,
        surfaceDim: LightThemeColors.grey.shade100,
        surfaceBright: Colors.white,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: LightThemeColors.grey.shade50,
        surfaceContainer: LightThemeColors.grey.shade50,
        surfaceContainerHigh: LightThemeColors.grey.shade100,
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
        displayLarge: TextStylesManager.font.copyWith(color: LightThemeColors.grey[900]),
        displayMedium: TextStylesManager.font.copyWith(color: LightThemeColors.grey[800]),
        displaySmall: TextStylesManager.font.copyWith(color: LightThemeColors.grey[900]),

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
        tabAlignment: TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: LightThemeColors.primary,
            width: 4,
          ),
          insets: EdgeInsets.zero,
        ),
        labelPadding: 0.edgeInsetsAll,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: InkRipple.splashFactory,
        dividerColor: Colors.transparent,
        unselectedLabelColor: LightThemeColors.unselectedIcon,
        labelStyle: TextStylesManager.font.s16.medium.setColor(
          LightThemeColors.primary,
        ),
        unselectedLabelStyle: TextStylesManager.font.s16.regular.setColor(
          LightThemeColors.grey.shade500,
        ),
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
