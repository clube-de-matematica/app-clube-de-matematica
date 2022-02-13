import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'db_servicos.dart';

/// TODO: [Widget] para inspecionar o banco de dados local.
class DbInspecaoPage extends StatefulWidget {
  const DbInspecaoPage({Key? key}) : super(key: key);

  @override
  _DbInspecaoPageState createState() => _DbInspecaoPageState();
}

class _DbInspecaoPageState extends State<DbInspecaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DriftDbViewer(Modular.get<DbServicos>().dbLocal),
          ));
        },
      ),
    );
  }
}
