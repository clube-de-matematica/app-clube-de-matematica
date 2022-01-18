import 'dart:async' show runZonedGuarded;
import 'dart:isolate' show Isolate, RawReceivePort;
import 'dart:ui' as ui
    show
        Paragraph,
        ParagraphBuilder,
        ParagraphConstraints,
        ParagraphStyle,
        TextStyle;

import 'package:flutter/foundation.dart'
    show
        DiagnosticPropertiesBuilder,
        DiagnosticsTreeStyle,
        FlutterError,
        FlutterErrorDetails,
        FlutterExceptionHandler,
        StringProperty,
        kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show
        Color,
        DiagnosticPropertiesBuilder,
        EdgeInsets,
        FlutterError,
        Offset,
        Paint,
        PaintingContext,
        RenderBox,
        Size,
        StringProperty,
        TextAlign,
        TextDirection;
import 'package:flutter/widgets.dart' as w show runApp;

import '../debug.dart';

///
///   Exemplo 1:
///
///```dart
///        void main() => ErrorHandler.runApp(MyApp());
///```
///
///   Exemplo 2:
///
///```dart
///        ErrorHandler.onError = (FlutterErrorDetails details) async {
///           await _reportError(details.exception, details.stack);
///        };
///```
/// O motivos de essa clase poder ser instanciada mais de uma vez, é para o caso de se
/// querer utilizar um [ErrorHandler] diferente em um determinado módulo do app.
class ErrorHandler {
  /// Se já houver uma instância com a [key], ela será retornada e os demais parâmetros serão
  /// ignorados. Caso contrário, será criada uma instância com o [handler] e o [builder]
  /// fornecidos.
  /// [key] é utilizada para retornar essa instânia por meio do método estático [getOfKey].
  ///
  /// Se [handler] for `null`, [FlutterError.onError] continuará com o padrão do Flutter.
  ///
  /// Se [builder] for `null`, [ErrorWidget.builder] receberá o retorno de [_defaultErrorWidget].
  /// [ErrorWidget.builder] é o widget exibido quando ocorre um erro na construção de algum widget.
  ///
  /// Se [useFlutterErrorWidget] for `true` será usado o [ErrorWidget.builder] padrão do
  /// Flutter, independentemente do valor de [builder]. O padrão é `false`.
  factory ErrorHandler(
    String key, {
    FlutterExceptionHandler? handler,
    ErrorWidgetBuilder? builder,
    bool useFlutterErrorWidget = false,
  }) {
    return getOfKey(key) ??
        () {
          return _instances[key] = ErrorHandler._(
            key,
            handler: handler,
            builder: builder,
            useFlutterErrorWidget: useFlutterErrorWidget,
          );
        }();
  }
  ErrorHandler._(
    this.key, {
    FlutterExceptionHandler? handler,
    ErrorWidgetBuilder? builder,
    bool useFlutterErrorWidget = false,
  }) {
    if (useFlutterErrorWidget) {
      builder = null;
    } else {
      builder ??= (FlutterErrorDetails details) => _defaultErrorWidget(details);
    }
    ensureInitialized();
    set(builder: builder, handler: handler);
  }

  ///Instâncias desta classe.
  static final _instances = <String, ErrorHandler>{};

  ///Key para [this] em [_instances].
  final String key;

  ///[key] da instância usada em [runApp].
  static const keyRoot = "root";

  ///Retorna a instância assossiada à [key].
  ///Retorna `null` se a instância não for encontrada.
  static ErrorHandler? getOfKey(String key) => _instances[key];

  ///Retorna a instância usada em [runApp].
  ///Retorna `null` se [runApp] ainda não foi executado.
  static ErrorHandler? getRoot() => getOfKey(keyRoot);

  /// Manipulador de erros padrão do Flutter.
  ///
  /// Ao executar essa função tenha certeza que [WidgetsFlutterBinding.ensureInitialized]
  /// já foi chamado.
  static final FlutterExceptionHandler? oldOnError =
      (WidgetsBinding.instance != null)
          ? FlutterError.onError
          : () {
              WidgetsFlutterBinding.ensureInitialized();
              return FlutterError.onError;
            }.call();

  /// Construtor do Widget de erro padrão do Flutter.
  ///
  /// Ao executar essa função tenha certeza que [WidgetsFlutterBinding.ensureInitialized]
  /// já foi chamado.
  static final ErrorWidgetBuilder _oldBuilder = () {
    WidgetsFlutterBinding.ensureInitialized();
    return ErrorWidget.builder;
  }.call();

  ///Usado para evitar que [runApp] seja chamado mais de uma vez.
  static bool _ranApp = false;

  /// Manipulador de erros.
  set onError(FlutterExceptionHandler handler) => set(handler: handler);

  /// Redefinir para omanipulador de erros padrão do Flutter.
  void resetOnError() => set(handler: oldOnError);

  /// Construtor do Widget de erro.
  set builder(ErrorWidgetBuilder builder) => set(builder: builder);

  /// Redefinir para o construtor do Widget de erro padrão do Flutter.
  void resetBuilder() => set(builder: _oldBuilder);

  ///Garantir que [oldOnError] e [_oldBuilder] sejam atribuídos antes da substituição de
  ///[FlutterError.onError] e [FlutterError.onError].
  static void ensureInitialized() {
    if (_instances.isEmpty) {
      oldOnError.toString();
      _oldBuilder.toString();
    }
  }

  /// Definir o manipulador de erros e o construtor do Widget de erro.
  /// Nada será feito com os parâmetros nulos.
  void set({
    Widget Function(FlutterErrorDetails details)? builder,
    void Function(FlutterErrorDetails details)? handler,
  }) {
    if (builder != null || handler != null) {
      WidgetsFlutterBinding.ensureInitialized();

      if (builder != null) ErrorWidget.builder = builder;

      if (handler != null) {
        final onError = (FlutterErrorDetails details) {
          // Se houver um erro no manipulador de erros customizado, queremos saber sobre isso.
          // runZonedGuarded deve ser usado para o tratamento pois também lida com erros
          // assíncronos, ao contrário de try{}catch(){}.
          runZonedGuarded(
            () => handler(details),
            (error, stack) {
              assert(Debug.printLine());
              assert(
                Debug.print("O FlutterError.onError lançou uma exceção", "*"),
              );
              assert(
                Debug.print("O FlutterError.onError padrão será chamado", "*"),
              );
              assert(Debug.printLine());

              assert(Debug.print("DETALHES DO ERRO ORIGINAL", "*"));
              oldOnError?.call(details);

              assert(
                  Debug.print("DETALHES DO ERRO EM FlutterError.onError", "*"));
              oldOnError?.call(getDetails(error, stack));
            },
          );
        };

        FlutterError.onError = onError;
        assert(
          onError != oldOnError,
          "oldOnError foi atribuído após a substituição de [FlutterError.onError]." +
              "\n" +
              "Certifique-se de chamar [ErrorHandler.ensureInitialized] antes de " +
              "substituir [FlutterError.onError].",
        );
      }
    }
  }

  ///Refinir o manipulador de erros e o construtor do Widget de erro para os padrões do Flutter.
  void reset() {
    ErrorWidget.builder = _oldBuilder;
    FlutterError.onError = oldOnError;
  }

  ///Redefine [ErrorWidget.builder] e [FlutterError.onError], e remove a instância.
  void dispode() {
    reset();
    _instances.remove(key);
  }

  /// Invoca a rotina de tratamento de erro.
  /// Se [usinOldOnError] for `true`, [oldOnError] será chamado, caso contrário chama-se
  /// [FlutterError.reportError]. O parão é `false`.
  ///
  /// Se [usinOldOnError] for `false`, esse método não deve ser invocado dentro da rotina
  /// [FlutterError.onError], pois isso causaria um loop, uma vez que ela é chamada dentro de
  /// [FlutterError.reportError], que, nessa condição, é invocado aqui em [reportError].
  static void reportError(
    FlutterErrorDetails details, {
    bool usinOldOnError = false,
  }) {
    if (usinOldOnError) {
      // Caso FlutterError.onError não tenha sido substituído, a condição evitará um loop se
      // ocorrer um erro em oldOnError.
      if (oldOnError != FlutterError.onError) oldOnError?.call(details);
    } else {
      // Chame a rotina Flutter 'onError'.
      FlutterError.reportError(details);
    }
  }

  ///Produz um objeto [FlutterErrorDetails].
  static FlutterErrorDetails getDetails(dynamic exception, StackTrace stack) {
    return FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: 'error_handler.dart',
    );
  }

  /// Envolva o aplicativo Flutter no manipulador de erros antes de chamar [w.runApp].
  ///
  /// Cria uma instância de [ErrorHandler] com o [handler] e [builder] fornecidos.
  ///
  /// Se [handler] for `null`, [FlutterError.onError] continuará com o padrão do Flutter.
  ///
  /// Se [builder] for `null`, [ErrorWidget.builder] receberá o retorno de [_defaultErrorWidget].
  ///
  /// Se [useFlutterErrorWidget] for `true` será usado o [ErrorWidget.builder] padrão do
  /// Flutter, independentemente do valor de [builder]. O padrão é `false`.
  ///
  /// [init] é uma função para ser executada antes de chamar o método runApp() do Flutter.
  ///
  /// Se, por exemplo, o app utiliza o Firebase, Firebase.initializeApp() deve ser colocado
  /// dentro de [init].
  static void runApp(
    Widget app, {
    void Function(FlutterErrorDetails)? handler,
    Widget Function(FlutterErrorDetails)? builder,
    Future<void> Function()? init,
    bool useFlutterErrorWidget = false,
  }) async {
    /* // Para detectar qualquer erro 'Dart' ocorrendo 'fora' da estrutura do Flutter.
    runZonedGuarded<Future<void>>(
      () async { */
    // Não pode ser usado corretamente se for chamado novamente e, portanto, não continue.
    if (_ranApp) return;

    _ranApp = true;

    // Capture quaisquer erros na estrutura do Flutter.
    ErrorHandler(
      keyRoot,
      handler: handler,
      builder: builder,
      useFlutterErrorWidget: useFlutterErrorWidget,
    );

    if (!kIsWeb) {
      // Isolate ainda não tem suporte para web.
      // Capture quaisquer erros na função main() após este método ser chamado.
      // Teoricamente, esta rotina nunca será chamada, pois o erro seria capturado
      ///primeiramente pela zona raíz [Zone.root].
      Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
        assert(
          Debug.printBetweenLine(
              "ERRO DETECTADO PELO Isolate.current.addErrorListener"),
        );
        var isolateError = pair as List;
        reportError(
          getDetails(
            isolateError.first.toString(),
            StackTrace.fromString(isolateError.last.toString()),
          ),
        );
      }).sendPort);
    }

    await init?.call();
    w.runApp(app);
    /* },
      (error, stackTrace) {
        assert(Debug.printBetweenLine("ERRO DETECTADO PELO runZonedGuarded"));
        reportError(_getDetails(error, stackTrace));
      },
    ); */
  }
}

/// Retorna o Widget de erro customizado.
Widget _defaultErrorWidget(FlutterErrorDetails details) {
  String message;
  try {
    message = "Erro\n\n" + details.exception.toString() + "\n\n";
    /* 
    List<String> stackTrace = details.stack.toString().split("\n");
    
    int length = stackTrace.length > 5 ? 5 : stackTrace.length;

    for (var i = 0; i < length; i++) {
      message += stackTrace[i] + "\n";
    } 
    */
    message += details.stack.toString();
  } catch (error, stack) {
    message = 'Erro';
    assert(Debug.printBetweenLine('Error ao gerar a mensagem de erro.'));
    assert(Debug.print(error));
    assert(Debug.printBetweenLine(stack, ""));
  }

  final Object exception = details.exception;
  return _WidgetError(
    message: message,
    error: exception is FlutterError ? exception : null,
  );
}

/// Esta classe está fazendo coisas intencionalmente usando os primitivos de baixo nível
/// para evitar depender de quaisquer subsistemas que possam ter terminado em um estado
/// instável - afinal, essa classe é usada principalmente quando as coisas dão errado.
class _WidgetError extends LeafRenderObjectWidget {
  _WidgetError({this.message = '', FlutterError? error})
      : _flutterError = error,
        super(key: UniqueKey());

  /// A mensagem a ser exibida.
  final String message;
  final FlutterError? _flutterError;

  @override
  RenderBox createRenderObject(BuildContext context) => _ErrorBox(message);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_flutterError == null)
      properties.add(
        StringProperty('message', message, quoted: false),
      );
    else
      properties.add(
        _flutterError!.toDiagnosticsNode(
          style: DiagnosticsTreeStyle.whitespace,
        ),
      );
  }
}

/// [RenderBox] do widget de erro customizado.
/// Uma mensagem pode ser fornecida opcionalmente. Se uma mensagem for fornecida, será feita
/// uma tentativa de renderizá-la quando a caixa for renderizada.
class _ErrorBox extends RenderBox {
  _ErrorBox([this.message = '', this.fontSize = 14.0])
      : textStyle = _initTextStyle(fontSize) {
    try {
      if (message.isNotEmpty) {
        /// Geralmente, a melhor maneira de desenhar texto em um [RenderObject] é usar a
        /// classe [TextPainter]. Se você estiver procurando um código para criar, consulte
        /// o arquivo `paragraph.dart` e a classe [RenderParagraph].
        final ui.ParagraphBuilder builder = ui.ParagraphBuilder(paragraphStyle);
        builder.pushStyle(textStyle);
        builder.addText(message);
        _paragraph = builder.build();
      }
    } catch (error, stack) {
      assert(Debug.printBetweenLine(error, ""));
      assert(Debug.print(stack));
      // Deixado em branco intencionalmente.
    }
  }

  /// A mensagem para tentar exibir na hora da pintura.
  final String message;

  ui.Paragraph? _paragraph;

  @override
  double computeMaxIntrinsicWidth(double height) {
    return 100000.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return 100000.0;
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performResize() {
    size = constraints.constrain(const Size(100000.0, 100000.0));
  }

  /// A distância para colocar em torno do texto.
  ///
  /// O preenchimento é ignorado se a caixa de erro for menor que o preenchimento.
  ///
  /// Veja também:
  ///
  /// * [minimumWidth] , que controla a largura da caixa antes de
  // o preenchimento horizontal é aplicado.
  EdgeInsets padding = const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0);

  /// A largura abaixo da qual o preenchimento horizontal não é aplicado.
  ///
  /// Se o preenchimento esquerdo e direito reduzir a largura disponível para menos que
  /// esse valor, o texto é renderizado alinhado com a borda esquerda.
  double minimumWidth = 200.0;

  /// A cor a ser usada ao pintar o plano de fundo de objetos [RenderBox].
  /// Um cinza claro.
  Color backgroundColor = const Color(0xF0C0C0C0);

  /// O estilo de texto a ser usado ao pintar objetos [RenderBox].
  /// Uma fonte sans-serif cinza escuro.
  ui.TextStyle textStyle;

  final double fontSize;

  static ui.TextStyle _initTextStyle([double fontSize = 18.0]) {
    ui.TextStyle result = ui.TextStyle(
      color: const Color(0xFF303030),
      fontFamily: 'sans-serif',
      fontSize: fontSize,
    );
    return result;
  }

  /// O estilo de parágrafo a ser usado ao pintar objetos [RenderBox].
  ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    try {
      context.canvas.drawRect(offset & size, Paint()..color = backgroundColor);
      if (_paragraph != null) {
        final paragraph = this._paragraph!;
        double width = size.width;
        double left = 0.0;
        // Garantir a vizualização abaixo da barra de status.
        double top = 32.0;
        if (width > padding.left + minimumWidth + padding.right) {
          width -= padding.left + padding.right;
          left += padding.left;
        }
        paragraph.layout(ui.ParagraphConstraints(width: width));
        if (size.height > padding.top + paragraph.height + padding.bottom) {
          top += padding.top;
        }

        context.canvas.drawParagraph(paragraph, offset + Offset(left, top));
      }
    } catch (error, stack) {
      assert(Debug.printBetweenLine(error, ""));
      assert(Debug.print(stack));
      // Deixado em branco intencionalmente.
    }
  }
}
