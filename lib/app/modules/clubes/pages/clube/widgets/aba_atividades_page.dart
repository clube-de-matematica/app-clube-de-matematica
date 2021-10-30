import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../clube_page.dart';

/// A subpágina exibida na aba "Atividades" da página do [clube].
class AtividadesPage extends StatelessWidget {
  const AtividadesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clube = ClubePage.of(context).controller.clube;
    return Observer(builder: (context) {
      return ListView(
        children: [],
      );
    });
  }
}
