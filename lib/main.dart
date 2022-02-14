import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/clube_de_matematica_module.dart';
import 'app/clube_de_matematica_widget.dart';
import 'app/configure_supabase.dart';
import 'app/services/preferencias_servicos.dart';
import 'app/shared/models/debug.dart';
import 'app/shared/models/exceptions/error_handler.dart';

bool get _usarFirebaseCrashlytics => (!Debug.inDebugger || false) && !kIsWeb;

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //final db = FirebaseFirestore.instance;
  //await testSqliteRepository();
  runZonedGuarded<Future<void>>(
    () async {
      ErrorHandler.runApp(
        ModularApp(
          module: ClubeDeMatematicaModule(),
          child: ClubeDeMatematicaWidget(),
        ),
        handler: (FlutterErrorDetails details) {
          assert(
            Debug.print("Executando FlutterError.onError customizado", "*"),
          );
          //Executar o comportamento padrão.
          ErrorHandler.oldOnError?.call(details);

          //Executar o comportamento personalizado.
          if (_usarFirebaseCrashlytics) {
            if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
              FirebaseCrashlytics.instance.recordError(
                details.exceptionAsString(),
                details.stack,
                reason: details.context,
                information: details.informationCollector?.call() ?? [],
                printDetails: false,
                //fatal: true,
              );
              //throw "Testando o envio de relatório de erro.";
            }
          }
        },
        init: _init,
        //useFlutterErrorWidget: true,
      );
    },
    (error, stackTrace) {
      assert(
        Debug.printBetweenLine(
            "Erro detectado pelo runZonedGuarded em main()", "*"),
      );
      final detail = ErrorHandler.getDetails(error, stackTrace);
      ErrorHandler.reportError(detail);
      try {
        runApp(ErrorWidget.builder(detail));
      } catch (_) {}
    },
  );

  /* 
  await _init();
  runApp(ModularApp(
      module: ClubeDeMatematicaModule(),
      child: ClubeDeMatematicaWidget(),
    ),
  ); 
  */
}

Future<void> _init() async {
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
  if (_usarFirebaseCrashlytics)
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  //=======================================================================================
  //=======================================================================================
  await Preferencias.inicializar();
  await initializeSupabase();
}

///Lógica executada antes da inicialização do [Firebase] ser concluída.
Future<void> _initBeforeCrashlytics() async {
  //Garantir que as dependências assíncronas concluam sua inicialização.
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializando FlutterFire
  //Não depende de conexão com a internet.
  await Firebase.initializeApp();
}
