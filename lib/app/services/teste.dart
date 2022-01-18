import 'package:clubedematematica/app/services/db_servicos.dart';
import 'package:clubedematematica/app/shared/repositories/drift/drift_db.dart';
import 'package:clubedematematica/app/shared/repositories/interface_db_repository.dart';
import 'package:clubedematematica/app/shared/repositories/supabase/supabase_db_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

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
          final db = DbServicos(DriftDb(), Modular.get<SupabaseDbRepository>());

          /* getApplicationDocumentsDirectory().then((dir) {
            DatabaseList.open(context, path: dir.path);
          }); */
        },
      ),
    );
  }
}
