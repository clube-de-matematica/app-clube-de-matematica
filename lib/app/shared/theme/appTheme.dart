import 'package:flutter/material.dart';

///Tema usado no aplicativo.
class AppTheme {
  static final _instance = AppTheme._();
  AppTheme._();
  factory AppTheme() => _instance;
  static AppTheme get instance => _instance;

  static MaterialColor obterAmostra(Color cor) => MaterialColor(
        cor.value,
        {
          50: Color.fromRGBO(cor.red, cor.green, cor.blue, .1),
          100: Color.fromRGBO(cor.red, cor.green, cor.blue, .2),
          200: Color.fromRGBO(cor.red, cor.green, cor.blue, .3),
          300: Color.fromRGBO(cor.red, cor.green, cor.blue, .4),
          400: Color.fromRGBO(cor.red, cor.green, cor.blue, .5),
          500: Color.fromRGBO(cor.red, cor.green, cor.blue, .6),
          600: Color.fromRGBO(cor.red, cor.green, cor.blue, .7),
          700: Color.fromRGBO(cor.red, cor.green, cor.blue, .8),
          800: Color.fromRGBO(cor.red, cor.green, cor.blue, .9),
          900: Color.fromRGBO(cor.red, cor.green, cor.blue, 1),
        },
      );

  static MaterialColor get primarySwatch => Colors.teal;

  static Color get corAcerto => Colors.green[200]!;

  static Color get corErro => Colors.red[200]!;

  ///Usada para almentar a fonte de todos os [TextStyle] do tema de forma proporcional.
  static double _escala = 1.0;

  ///Usada para almentar a fonte de todos os [TextStyle] do tema de forma proporcional.
  static double get escala => _escala;

  ///Usada para almentar a fonte de todos os [TextStyle] do tema de forma proporcional.
  static set escala(double value) {
    assert(value > 0);
    if (value > 0) _escala = value;
  }

  ///Esquema de cores do App.
  final _colors = ColorScheme.fromSeed(
    seedColor: Color(0xFF009688), // Colors.teal[500]
  );
/*   final _colors = ColorScheme.fromSwatch(
    primarySwatch: primarySwatch,
    //accentColor: primarySwatch, // Colors.teal[500].value == 0xFF009688 // secondary
    backgroundColor: Color(0xfff4fbf8),
    cardColor: Color(0xfff4fbf8),
    errorColor: Color(0xffba1a1a),
    brightness: Brightness.light,
  ); */

  ThemeData get light {
    ThemeData _temp = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: _colors,
      textTheme: _textTheme(),
      appBarTheme: appBarTheme(colors: _colors, isPrimary: true),
      drawerTheme: DrawerThemeData(
        backgroundColor: _colors.surface,
      ),
      scaffoldBackgroundColor: _colors.background,
      iconTheme: IconThemeData(
        color: _colors.onSurface,
        opacity: 1.0,
        size: 24.0,
        applyTextScaling: true,
      ),
      //ver https://codelabs.developers.google.com/codelabs/flutter-boring-to-beautiful?hl=pt-br#4
      //pageTransitionsTheme: pageTransitionsTheme,
      //cardTheme: cardTheme(),
      //listTileTheme: listTileTheme(_colors),
      //bottomAppBarTheme: bottomAppBarTheme(_colors),
      //bottomNavigationBarTheme: bottomNavigationBarTheme(_colors),
      //navigationRailTheme: navigationRailTheme(_colors),
      //tabBarTheme: tabBarTheme(_colors),
    );

    return _temp;

/*     return _temp.copyWith(
            iconTheme: IconThemeData(
        color: _onSurface,
        opacity: 1.0,
        size: 24.0,
      ),
      inputDecorationTheme: _temp.inputDecorationTheme.copyWith(
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    ); */
  }

  _textTheme() {
    return Typography.material2021(
      platform: TargetPlatform.android,
      colorScheme: _colors,
    ).black.apply(
          fontSizeFactor: _escala,
          //bodyColor: _colors.onSurface,
          //displayColor: _colors.onSurface,
        );
  }

  static AppBarTheme appBarTheme({
    required ColorScheme colors,
    bool isPrimary = true,
  }) {
    final primary = colors.primary;
    final background = colors.surface;
    final onPrimary = colors.onPrimary;
    final onBackground = colors.onSurface;
    final iconTheme = IconThemeData(
      color: isPrimary ? onPrimary : onBackground,
      opacity: 1.0,
      size: 24.0,
    );
    return AppBarTheme(
      elevation: 0,
      backgroundColor: isPrimary ? primary : background,
      foregroundColor: isPrimary ? onPrimary : onBackground,
      actionsIconTheme: iconTheme,
      iconTheme: iconTheme,
      //titleTextStyle: ,
    );
  }

/**
  static TextTheme _defineTextTheme({Color? color, required ThemeData theme}) {
    var _temp = theme;

    return _temp.textTheme.copyWith(
      displayLarge: _temp.textTheme.displayLarge?.copyWith(
        color: color,
        fontSize: _escala * 16,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
      ),
      displayMedium: _temp.textTheme.displayMedium?.copyWith(
        color: color,
        fontSize: _escala * 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
      ),
      displaySmall: _temp.textTheme.displaySmall?.setEscalaFontSize(_escala),
      headlineMedium:
          _temp.textTheme.headlineMedium?.setEscalaFontSize(_escala),
      headlineSmall: _temp.textTheme.headlineSmall?.setEscalaFontSize(_escala),
      titleLarge: _temp.textTheme.titleLarge?.setEscalaFontSize(_escala),
      titleMedium: _temp.textTheme.titleMedium?.copyWith(
        color: color,
        fontSize: _escala * 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      titleSmall: _temp.textTheme.titleSmall?.copyWith(
        color: color,
        fontSize: _escala * 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      bodyLarge: _temp.textTheme.bodyLarge?.copyWith(
        color: color,
        fontSize: _escala * 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0,
      ),
      bodyMedium: _temp.textTheme.bodyMedium?.copyWith(
        color: color,
        fontSize: _escala * 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0,
      ),
      bodySmall: _temp.textTheme.bodySmall?.copyWith(
        color: color,
        fontSize: _escala * 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      labelLarge: _temp.textTheme.labelLarge?.copyWith(
        color: color?.withOpacity(0.45),
        fontSize: _escala * 14,
        //fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,

        ///Também define o espaçamento entre os caracteres.
        letterSpacing: 1.8,
      ),
      labelSmall: _temp.textTheme.labelSmall?.copyWith(
        color: color,
        fontSize: _escala * 10,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
    );
  }

  MeuTema() {
    _temaClaro = ThemeData(
    primarySwatch: Colors?.teal,
    brightness: Brightness?.light,
    primaryColor: _corPrimary,
    primaryColorBrightness: Brightness?.dark,
    primaryColorLight: const Color( 0xffb2dfdb ),
    primaryColorDark: _corPrimaryVariant,
    accentColor: _corPrimary,
    accentColorBrightness: Brightness?.dark,
    canvasColor: const Color( 0xfffafafa ),
    scaffoldBackgroundColor: const Color( 0xfffafafa ),
    bottomAppBarColor: _corSurface,
    cardColor: _corSurface,
    dividerColor: const Color( 0x1f000000 ),
    highlightColor: const Color( 0x66bcbcbc ),
    splashColor: const Color( 0x66c8c8c8 ),
    selectedRowColor: const Color( 0xfff5f5f5 ),
    unselectedWidgetColor: const Color( 0x8a000000 ),
    disabledColor: const Color( 0x61000000 ),
    buttonColor: const Color( 0xffe0e0e0 ),
    toggleableActiveColor: const Color( 0xff00897b ),
    secondaryHeaderColor: const Color( 0xffe0f2f1 ),
    textSelectionColor: _corBackground,
    cursorColor: _corOnSurface,
    textSelectionHandleColor: const Color( 0xff4db6ac ),
    backgroundColor: _corBackground,
    dialogBackgroundColor: _corSurface,
    indicatorColor: _corPrimary,
    hintColor: const Color( 0x8a000000 ),
    errorColor: _corError,**/
}
