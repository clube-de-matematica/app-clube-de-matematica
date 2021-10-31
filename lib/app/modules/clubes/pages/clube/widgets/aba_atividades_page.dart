import 'package:clubedematematica/app/modules/clubes/shared/models/atividade.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../clube_page.dart';
import 'categoria.dart';

/// A subpágina exibida na aba "Atividades" da página do [clube].
class AtividadesPage extends StatelessWidget {
  const AtividadesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = ClubePage.of(context);
    final controle = widget.controller;
    final clube = controle.clube;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: clube.capa,
        child: Icon(
          Icons.add,
          color: widget.corTextoCapa,
          size: 28.0,
        ),
        onPressed: () => controle.abrirPaginaCriarAtividade(context),
      ),
      body: Observer(builder: (context) {
        return ListView(
          children: [
            _CategoriaAtividade(
              categoria: 'Atividades',
              cor: clube.capa,
              atividades: controle.atividades,
            )
          ],
        );
      }),
    );
  }
}

/// O widget para exibir uma categoria de atividades.
class _CategoriaAtividade extends Categoria {
  final String categoria;
  final Color cor;
  final List<Atividade> atividades;

  _CategoriaAtividade({
    Key? key,
    required this.categoria,
    required this.cor,
    this.atividades = const [],
  }) : super(
          key: key,
          categoria: categoria,
          cor: cor,
          itens: List.generate(
            atividades.length,
            (index) {
              return Observer(builder: (context) {
                final atividade = atividades[index];
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  title: Text(atividade.nome),
                  subtitle: Text(atividade.descricao ?? ''),
                  onTap: () => ClubePage.of(context)
                      .controller
                      .abrirPaginaAtividade(context, atividade),
                );
              });
            },
          ),
        );
}
