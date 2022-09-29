import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/clube_de_matematica_module.dart';
import 'app/clube_de_matematica_widget.dart';
import 'app/configure_supabase.dart';
import 'app/services/preferencias_servicos.dart';
import 'app/shared/models/exceptions/clube_error.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //final db = FirebaseFirestore.instance;
  //await testSqliteRepository();
  ClubeError.runApp(
    ModularApp(
      module: ClubeDeMatematicaModule(),
      child: ClubeDeMatematicaWidget(),
    ),
    init: _init,
  );
}

Future<void> _init() async {
  //Garantir que as dependências assíncronas concluam sua inicialização.
  WidgetsFlutterBinding.ensureInitialized();
  await Preferencias.inicializar();
  await initializeSupabase();
}