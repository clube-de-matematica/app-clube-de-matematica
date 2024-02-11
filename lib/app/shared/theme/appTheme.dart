import 'package:flutter/material.dart';

import '../extensions.dart';

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

  ThemeData get temaClaro {
    final temp = ThemeData(primarySwatch: primarySwatch);
    final onSurface = Colors.black.withOpacity(0.7);

    return temp.copyWith(
      colorScheme: temp.colorScheme.copyWith(onSurface: onSurface),
      appBarTheme: temp.appBarTheme.copyWith(
        toolbarTextStyle:
            temp.appBarTheme.toolbarTextStyle?.setEscalaFontSize(_escala),
        titleTextStyle:
            temp.appBarTheme.titleTextStyle?.setEscalaFontSize(_escala),
      ),
      bannerTheme: temp.bannerTheme.copyWith(
        contentTextStyle:
            temp.bannerTheme.contentTextStyle?.setEscalaFontSize(_escala),
      ),
      bottomNavigationBarTheme: temp.bottomNavigationBarTheme.copyWith(
        selectedLabelStyle: temp.bottomNavigationBarTheme.selectedLabelStyle
            ?.setEscalaFontSize(_escala),
        unselectedLabelStyle: temp.bottomNavigationBarTheme.unselectedLabelStyle
            ?.setEscalaFontSize(_escala),
      ),
      chipTheme: temp.chipTheme.copyWith(
        labelStyle: temp.chipTheme.labelStyle?.setEscalaFontSize(_escala),
        secondaryLabelStyle:
            temp.chipTheme.secondaryLabelStyle?.setEscalaFontSize(_escala),
      ),
      cupertinoOverrideTheme: temp.cupertinoOverrideTheme?.copyWith(
        textTheme: temp.cupertinoOverrideTheme?.textTheme?.copyWith(
          actionTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.actionTextStyle
              .setEscalaFontSize(_escala),
          textStyle: temp.cupertinoOverrideTheme?.textTheme?.textStyle
              .setEscalaFontSize(_escala),
          pickerTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.pickerTextStyle
              .setEscalaFontSize(_escala),
          navTitleTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.navTitleTextStyle
              .setEscalaFontSize(_escala),
          tabLabelTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.tabLabelTextStyle
              .setEscalaFontSize(_escala),
          navActionTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.navActionTextStyle
              .setEscalaFontSize(_escala),
          navLargeTitleTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.navLargeTitleTextStyle
              .setEscalaFontSize(_escala),
          dateTimePickerTextStyle: temp
              .cupertinoOverrideTheme?.textTheme?.dateTimePickerTextStyle
              .setEscalaFontSize(_escala),
        ),
      ),
      dataTableTheme: temp.dataTableTheme.copyWith(
        dataTextStyle:
            temp.dataTableTheme.dataTextStyle?.setEscalaFontSize(_escala),
        headingTextStyle:
            temp.dataTableTheme.headingTextStyle?.setEscalaFontSize(_escala),
      ),
      dialogTheme: temp.dialogTheme.copyWith(
        titleTextStyle:
            temp.dialogTheme.titleTextStyle?.setEscalaFontSize(_escala),
        contentTextStyle:
            temp.dialogTheme.contentTextStyle?.setEscalaFontSize(_escala),
      ),
      iconTheme: IconThemeData(
        color: onSurface,
        opacity: 1.0,
        size: 24.0,
      ),
      inputDecorationTheme: temp.inputDecorationTheme.copyWith(
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        labelStyle: temp.inputDecorationTheme.labelStyle
            ?.setEscalaFontSize(_escala, 16.0),
        hintStyle:
            temp.inputDecorationTheme.hintStyle?.setEscalaFontSize(_escala),
        errorStyle:
            temp.inputDecorationTheme.errorStyle?.setEscalaFontSize(_escala),
        helperStyle:
            temp.inputDecorationTheme.helperStyle?.setEscalaFontSize(_escala),
        prefixStyle:
            temp.inputDecorationTheme.prefixStyle?.setEscalaFontSize(_escala),
        suffixStyle:
            temp.inputDecorationTheme.suffixStyle?.setEscalaFontSize(_escala),
        counterStyle:
            temp.inputDecorationTheme.counterStyle?.setEscalaFontSize(_escala),
      ),
      navigationRailTheme: temp.navigationRailTheme.copyWith(
        selectedLabelTextStyle: temp.navigationRailTheme.selectedLabelTextStyle
            ?.setEscalaFontSize(_escala),
        unselectedLabelTextStyle: temp
            .navigationRailTheme.unselectedLabelTextStyle
            ?.setEscalaFontSize(_escala),
      ),
      popupMenuTheme: temp.popupMenuTheme.copyWith(
        textStyle: temp.popupMenuTheme.textStyle?.setEscalaFontSize(_escala),
      ),
      primaryTextTheme:
          temp.primaryTextTheme.overrideFontSizeInTextStyles(_escala),
      sliderTheme: temp.sliderTheme.copyWith(
        valueIndicatorTextStyle: temp.sliderTheme.valueIndicatorTextStyle
            ?.setEscalaFontSize(_escala),
      ),
      snackBarTheme: temp.snackBarTheme.copyWith(
        contentTextStyle:
            temp.snackBarTheme.contentTextStyle?.setEscalaFontSize(_escala),
      ),
      tabBarTheme: temp.tabBarTheme.copyWith(
        labelStyle: temp.tabBarTheme.labelStyle?.setEscalaFontSize(_escala),
      ),

      /* 
      textButtonTheme: ,
      elevatedButtonTheme: ,
      outlinedButtonTheme: ,
      */

      textTheme: temp.textTheme.copyWith(
        displayLarge: temp.textTheme.displayLarge?.copyWith(
          color: onSurface,
          fontSize: _escala * 16,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
        displayMedium: temp.textTheme.displayMedium?.copyWith(
          color: onSurface,
          fontSize: _escala * 14,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
        displaySmall: temp.textTheme.displaySmall?.setEscalaFontSize(_escala),
        headlineMedium: temp.textTheme.headlineMedium?.setEscalaFontSize(_escala),
        headlineSmall: temp.textTheme.headlineSmall?.setEscalaFontSize(_escala),
        titleLarge: temp.textTheme.titleLarge?.setEscalaFontSize(_escala),
        titleMedium: temp.textTheme.titleMedium?.copyWith(
          color: onSurface,
          fontSize: _escala * 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        titleSmall: temp.textTheme.titleSmall?.copyWith(
          color: onSurface,
          fontSize: _escala * 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        bodyLarge: temp.textTheme.bodyLarge?.copyWith(
          color: onSurface,
          fontSize: _escala * 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0,
        ),
        bodyMedium: temp.textTheme.bodyMedium?.copyWith(
          color: onSurface,
          fontSize: _escala * 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0,
        ),
        bodySmall: temp.textTheme.bodySmall?.copyWith(
          color: onSurface,
          fontSize: _escala * 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        labelLarge: temp.textTheme.labelLarge?.copyWith(
          color: onSurface.withOpacity(0.45),
          fontSize: _escala * 14,
          //fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,

          ///Também define o espaçamento entre os caracteres.
          letterSpacing: 1.8,
        ),
        labelSmall: temp.textTheme.labelSmall?.copyWith(
          color: onSurface,
          fontSize: _escala * 10,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      timePickerTheme: temp.timePickerTheme.copyWith(
        helpTextStyle:
            temp.timePickerTheme.helpTextStyle?.setEscalaFontSize(_escala),
        dayPeriodTextStyle:
            temp.timePickerTheme.dayPeriodTextStyle?.setEscalaFontSize(_escala),
        hourMinuteTextStyle: temp.timePickerTheme.hourMinuteTextStyle
            ?.setEscalaFontSize(_escala),
        inputDecorationTheme:
            temp.timePickerTheme.inputDecorationTheme?.copyWith(
          hintStyle: temp.timePickerTheme.inputDecorationTheme?.hintStyle
              ?.setEscalaFontSize(_escala),
          errorStyle: temp.timePickerTheme.inputDecorationTheme?.errorStyle
              ?.setEscalaFontSize(_escala),
          labelStyle: temp.timePickerTheme.inputDecorationTheme?.labelStyle
              ?.setEscalaFontSize(_escala),
          helperStyle: temp.timePickerTheme.inputDecorationTheme?.helperStyle
              ?.setEscalaFontSize(_escala),
          prefixStyle: temp.timePickerTheme.inputDecorationTheme?.prefixStyle
              ?.setEscalaFontSize(_escala),
          suffixStyle: temp.timePickerTheme.inputDecorationTheme?.suffixStyle
              ?.setEscalaFontSize(_escala),
          counterStyle: temp.timePickerTheme.inputDecorationTheme?.counterStyle
              ?.setEscalaFontSize(_escala),
        ),
      ),
      toggleButtonsTheme: temp.toggleButtonsTheme.copyWith(
        textStyle:
            temp.toggleButtonsTheme.textStyle?.setEscalaFontSize(_escala),
      ),
      tooltipTheme: temp.tooltipTheme.copyWith(
        textStyle: temp.tooltipTheme.textStyle?.setEscalaFontSize(_escala),
      ),
      typography: temp.typography.copyWith(
        black: temp.typography.black.overrideFontSizeInTextStyles(_escala),
        //Estas substituições estão gerando erro.
        //dense: temp.typography?.dense?.overrideFontSizeInTextStyles(_escala),
        //englishLike: temp.typography?.englishLike?.overrideFontSizeInTextStyles(_escala),
        //tall: temp.typography?.tall?.overrideFontSizeInTextStyles(_escala),
        white: temp.typography.white.overrideFontSizeInTextStyles(_escala),
      ),
    );
  }

  /** MeuTema() {
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
    errorColor: _corError,

    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme?.normal,
      minWidth: 88,
      height: 36,
      padding: const EdgeInsets?.only(top:0,bottom:0,left:16, right:16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _corOnSurface, width: 0, style: BorderStyle?.none, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(2?.0)),
      ),
      alignedDropdown: false ,
      buttonColor: const Color( 0xffe0e0e0 ),
      disabledColor: const Color( 0x61000000 ),
      highlightColor: const Color( 0x00000000 ),
      splashColor: _corBackground?.withOpacity(0?.25),
      focusColor: const Color( 0x1f000000 ),
      hoverColor: const Color( 0x0a000000 ),
      colorScheme: _esquemaDeCores,
    ),

    iconTheme: IconThemeData(
      color: _corOnSurface,
      opacity: 1,
      size: 24,
    ),

    primaryIconTheme: IconThemeData(
      color: _corSurface,
      opacity: 1,
      size: 24,
    ),

    accentIconTheme: IconThemeData(
      color: _corSurface,
      opacity: 1,
      size: 24,
    ),

    chipTheme: ChipThemeData(
      padding: const EdgeInsets?.only(top:4,bottom:4,left:4, right:4),
      labelPadding: const EdgeInsets?.only(top:0,bottom:0,left:8, right:8),
      brightness: Brightness?.light,
      backgroundColor: const Color( 0x1f000000 ),
      deleteIconColor: const Color( 0xde000000 ),
      disabledColor: const Color( 0x0c000000 ),
      selectedColor: const Color( 0x3d000000 ),
      secondarySelectedColor: const Color( 0x3d009688 ),
      labelStyle: TextStyle(
        color: const Color( 0xde000000 ),
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      secondaryLabelStyle: TextStyle(
        color: const Color( 0x3d000000 ),
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      shape: StadiumBorder( side: BorderSide(color: _corOnSurface, width: 0, style: BorderStyle?.none, ) ),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 20,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleMedium: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyMedium: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyLarge: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodySmall: TextStyle(
        color: const Color( 0x8a000000 ),
        fontSize: _escala * 12,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelLarge: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleSmall: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelSmall: TextStyle(
        color: _corOnSurface,
        fontSize: _escala * 10,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
    ),

    primaryTextTheme: TextTheme(
      titleLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 20,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleMedium: TextStyle(
        color: _corSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyMedium: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodySmall: TextStyle(
        color: const Color( 0xb3ffffff ),
        fontSize: _escala * 12,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleSmall: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelSmall: TextStyle(
        color: _corSurface,
        fontSize: _escala * 10,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
    ),

    accentTextTheme: TextTheme(
      titleLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 20,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleMedium: TextStyle(
        color: _corSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyMedium: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodyLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 16,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      bodySmall: TextStyle(
        color: const Color( 0xb3ffffff ),
        fontSize: _escala * 12,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelLarge: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      titleSmall: TextStyle(
        color: _corSurface,
        fontSize: _escala * 14,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      labelSmall: TextStyle(
        color: _corSurface,
        fontSize: _escala * 10,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      helperStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      hintStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      errorStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      //errorMaxLines: null,
      isDense: true,
      contentPadding: const EdgeInsets?.only(top:20,bottom:12,left:12, right:12),
      isCollapsed : false,
      prefixStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      suffixStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      counterStyle: TextStyle(
        color: _corOnSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
      filled: false,
      fillColor: const Color( 0x00000000 ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: _corOnSurface, width: 1, style: BorderStyle?.solid, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(4?.0)),
        gapPadding: 4
      ),
    ),

    sliderTheme: SliderThemeData(
      /*
      activeTrackColor: null,
      inactiveTrackColor: null,
      disabledActiveTrackColor: null,
      disabledInactiveTrackColor: null,
      activeTickMarkColor: null,
      inactiveTickMarkColor: null,
      disabledActiveTickMarkColor: null,
      disabledInactiveTickMarkColor: null,
      thumbColor: null,
      disabledThumbColor: null,
      thumbShape: null(),
      overlayColor: null,
      valueIndicatorColor: null,
      valueIndicatorShape: null(),
      showValueIndicator: null,
      */
      valueIndicatorTextStyle: TextStyle(
        color: _corSurface,
        //fontSize: null,
        fontWeight: FontWeight?.w400,
        fontStyle: FontStyle?.normal,
      ),
    ),

    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize?.tab,
      labelColor: _corSurface,
      unselectedLabelColor: const Color( 0xb2ffffff ),
    ),

    dialogTheme: DialogTheme(
      shape:     RoundedRectangleBorder(
        side: BorderSide(color: _corOnSurface, width: 0, style: BorderStyle?.none, ),
        borderRadius: const BorderRadius?.all(const Radius?.circular(0?.0)),
      )
    ),
  );
  } **/
}
