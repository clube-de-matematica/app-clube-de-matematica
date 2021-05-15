import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/clube_de_matematica_module.dart';
import 'app/clube_de_matematica_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); //Não depende de conexão com a internet.
  } on FirebaseException catch (e) {
    print(e.toString());
  }
  runApp(ModularApp(
    module: ClubeDeMatematicaModule(),
    child: ClubeDeMatematicaWidget(),
  ));
}
