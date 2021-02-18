// Esta classe foi criada com base em "katex_flutter.dart" do pacote "katex_flutter: ^4.0.2+26"
import 'package:catex/catex.dart';
import 'package:flutter/widgets.dart';

/// The basic WebView for displaying the created HTML String
class KaTeX {
  // a Text used for the rendered code as well as for the style
  final Text laTeXCode;

  // The delimiter to be used for inline LaTeX
  final String delimiter;

  // The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  ////////////////SAMY/////////////////
  List<InlineSpan> _blocosDoTexto = List();

  bool _temLaTex;

  List<InlineSpan> get blocosDoTexto => _blocosDoTexto;

  bool get temLaTex => _temLaTex;
  ////////////////SAMY/////////////////

  KaTeX(
      {Key key,
      @required this.laTeXCode,
      this.delimiter = r'$',
      this.displayDelimiter = r'$$'}){
    // Fetching the Widget's LaTeX code as well as it's [TextStyle]
    final String laTeXCode = this.laTeXCode.data;

    // Building [RegExp] to find any Math part of the LaTeX code by looking for the specified delimiters
    final String delimiter = this.delimiter.replaceAll(r'$', r'\$');
    final String displayDelimiter = this.displayDelimiter.replaceAll(r'$', r'\$');

    final String rawRegExp =
      '(($delimiter)([^$delimiter]*[^\\\\\\$delimiter])($delimiter)|($displayDelimiter)([^$displayDelimiter]*[^\\\\\\$displayDelimiter])($displayDelimiter))';
    List<RegExpMatch> matches =
      RegExp(rawRegExp, dotAll: true).allMatches(laTeXCode).toList();

    // Registrar se há alguma codificação LaTex
    if (matches.isNotEmpty) _temLaTex = true;

    int lastTextEnd = 0;

    matches.forEach((laTeXMatch) {
      // If there is an offset between the lat match (beginning of the [String] in first case), first adding the found [Text]
      // Se houver um deslocamento entre a última correspondência (início de [String] no primeiro caso), primeiro adicionando o [Texto] encontrado
      if (laTeXMatch.start > lastTextEnd)
        _blocosDoTexto.add(
            TextSpan(text: laTeXCode.substring(lastTextEnd, laTeXMatch.start)));
      // Adding the [CaTeX] widget to the children
      if (laTeXMatch.group(3) != null)
        _blocosDoTexto.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: CaTeX(laTeXMatch.group(3).trim())));
      else
        _blocosDoTexto.addAll([
          TextSpan(text: '\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: DefaultTextStyle.merge(
                child: CaTeX(laTeXMatch.group(6).trim())),
            /*style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 2)*/
          ),
          TextSpan(text: '\n')
        ]);
      lastTextEnd = laTeXMatch.end;
    });

    // If there is any text left after the end of the last match, adding it to children
    if (lastTextEnd < laTeXCode.length) {
      _blocosDoTexto.add(TextSpan(text: laTeXCode.substring(lastTextEnd)));
    }

    ////////////////SAMY/////////////////
    this._blocosDoTexto = _blocosDoTexto;
    ////////////////SAMY/////////////////
  }

  Text montar(List<InlineSpan> blocosDoTexto, TextStyle style){
    return Text.rich(TextSpan(
      children: blocosDoTexto,
      style: style
    ));
  }
}
