import 'dart:async' show runZonedGuarded;
import 'dart:isolate' show Isolate, RawReceivePort;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show FlutterError, FlutterErrorDetails, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as w show runApp;

import '../../../../firebase_options.dart';
import '../debug.dart';

/// O motivos de essa clase poder ser instanciada mais de uma vez, é para o caso de se
/// queira utilizar um [ClubeError] diferente em um determinado módulo do app.
class ClubeError {
  /// Se já houver uma instância com a [key], ela será retornada e os demais parâmetros serão
  /// ignorados.
  ///
  /// [key] é utilizada para retornar essa instânia por meio do método estático [getOfKey].
  factory ClubeError(String key) {
    return getOfKey(key) ?? (_instances[key] = ClubeError._(key));
  }

  ClubeError._(this.key);

  /// Usado para ativar o relatório de erros.
  static bool get _useErrorReport => (!Debug.inDebugger || false) && !kIsWeb;

  /// Instâncias desta classe.
  static final _instances = <String, ClubeError>{};

  /// Identificador da instância em [_instances].
  final String key;

  /// [key] da instância usada em [runApp].
  static const keyRoot = "root";

  /// Retorna a instância assossiada à [key].
  /// Retorna `null` se a instância não for encontrada.
  static ClubeError? getOfKey(String key) => _instances[key];

  /// Retorna a instância usada em [runApp].
  /// Retorna `null` se [runApp] ainda não foi executado.
  static ClubeError? getRoot() => getOfKey(keyRoot);

  /// Envia um relatório de erro para a fila de relatórios.
  static Future<void> reportError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  /// Envia um relatório de erro para a fila de relatórios usando um [FlutterErrorDetails].
  static void reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  }) async {
    FirebaseCrashlytics.instance.recordFlutterError(details, fatal: fatal);
  }

  /// Lógica executada para a inicialização do [FirebaseCrashlytics] ser concluída.
  static Future<void> _initCrashlytics() async {
    await _initBeforeCrashlytics();
    //=======================================================================================
    //------------ ESSE VALOR DEVE SER DEFINIDO PELAS PREFERÊNCIAS DO USUÁRIO ---------------
    //=======================================================================================
    ///Habilita/desabilita a coleta automática de dados pelo Crashlytics.
    ///Se a coleta automática de dados for desativada para o Crashlytics, os relatórios de
    ///falha serão armazenados no dispositivo. Para verificar os relatórios, use o método
    ///[FirebaseCrashlytics.checkForUnsentReports]. Use [FirebaseCrashlytics.sendUnsentReports]
    ///para fazer upload de relatórios existentes, mesmo quando a coleta automática de dados
    ///está desativada. Use [FirebaseCrashlytics.deleteUnsentReports] para excluir quaisquer
    ///relatórios armazenados no dispositivo sem enviá-los ao Crashlytics.
    if (_useErrorReport) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  /// Lógica executada antes da inicialização do [FirebaseCrashlytics] ser concluída.
  static Future<void> _initBeforeCrashlytics() async {
    //Garantir que as dependências assíncronas concluam sua inicialização.
    WidgetsFlutterBinding.ensureInitialized();

    //Inicializando FlutterFire
    //Não depende de conexão com a internet.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Produz um objeto [FlutterErrorDetails].
  static FlutterErrorDetails getDetails(
    dynamic exception,
    StackTrace stack, {
    String? library = 'clube_error.dart',
  }) {
    return FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: library,
      //context: mensagem == null ? null : DiagnosticsNode.message(mensagem),
    );
  }

  /// Envolva o aplicativo Flutter no manipulador de erros antes de chamar [w.runApp].
  ///
  /// Cria uma instância de [ClubeError].
  ///
  /// [init] é uma função para ser executada antes de chamar o método runApp() do Flutter.
  ///
  /// Se, por exemplo, o app utiliza o Firebase, Firebase.initializeApp() deve ser colocado
  /// dentro de [init].
  ///
  /// Deve ser chamado uma única vez.
  static void runApp(
    Widget app, {
    Future<void> Function()? init,
  }) async {
    // Não pode ser usado corretamente se for chamado novamente e, portanto, não continue.
    if (getRoot() != null) {
      assert(
        Debug.printBetweenLine(
            "ClubeError.runApp() já foi chamado anteriormente."),
      );
      return;
    }

    // Para detectar qualquer erro 'Dart' ocorrendo 'fora' da estrutura do Flutter.
    runZonedGuarded<Future<void>>(
      () async {
        await _initCrashlytics();

        // Capture quaisquer erros na estrutura do Flutter.
        ClubeError(keyRoot);

        if (!kIsWeb) {
          // Isolate ainda não tem suporte para web.
          // Capture quaisquer erros na função main() após este método ser chamado.
          // Teoricamente, esta rotina nunca será chamada, pois o erro seria capturado
          // primeiramente pela zona raíz [Zone.root].
          Isolate.current.addErrorListener(RawReceivePort((pair) async {
            assert(
              Debug.printBetweenLine(
                  "ERRO DETECTADO PELO Isolate.current.addErrorListener"),
            );
            final List<dynamic> errorAndStacktrace = pair;
            await reportError(
              errorAndStacktrace.first,
              errorAndStacktrace.last,
              fatal: true,
            );
          }).sendPort);
        }

        // Por padrão os erros não tratados serão considerados como fatais.
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;

        await init?.call();
        w.runApp(app);
      },
      (error, stackTrace) {
        assert(Debug.printBetweenLine("ERRO DETECTADO PELO runZonedGuarded"));
        reportError(error, stackTrace, fatal: true);
      },
    );
  }
}
