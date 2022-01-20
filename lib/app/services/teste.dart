import 'package:clubedematematica/app/services/db_servicos.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TesteDbPage extends StatefulWidget {
  const TesteDbPage({Key? key}) : super(key: key);

  @override
  _TesteDbPageState createState() => _TesteDbPageState();
}

class _TesteDbPageState extends State<TesteDbPage> {
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
