import 'dart:developer';

import 'package:clubedematematica/app/modules/clubes/modules/atividades/models/atividade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/utils/tema_clube.dart';
import '../clube_controller.dart';
import 'categoria.dart';

/// A subpágina exibida na aba "Atividades" da página do [clube].
class AtividadesPage extends StatefulWidget {
  const AtividadesPage({Key? key}) : super(key: key);

  @override
  State<AtividadesPage> createState() => _AtividadesPageState();
}

class _AtividadesPageState extends State<AtividadesPage> {
  TemaClube get temaClube => Modular.get<TemaClube>();

  ClubeController get controle => Modular.get<ClubeController>();

  @override
  Widget build(BuildContext context) {
    construirFloatingActionButton() {
      final usuario = controle.usuarioApp;
      if (controle.clube.permissaoCriarAtividade(usuario.id)) {
        return FloatingActionButton(
          backgroundColor: temaClube.primaria,
          child: Icon(
            Icons.add,
            color: temaClube.textoPrimaria,
            size: 28.0,
          ),
          onPressed: () => controle.abrirPaginaCriarAtividade(context),
        );
      }
    }

    return Scaffold(
      floatingActionButton: construirFloatingActionButton(),
      body: RefreshIndicator(
        backgroundColor: temaClube.primaria,
        color: temaClube.textoPrimaria,
        onRefresh: controle.sincronizarAtividades,
        child: Observer(builder: (_) {
          return ListView(
            children: [
              _CategoriaAtividade(
                atividades: controle.atividades,
                onAtividade: controle.abrirPaginaAtividade,
              )
            ],
          );
        }),
      ),
    );
  }
}

/// O widget para exibir uma categoria de atividades.
class _CategoriaAtividade extends Categoria {
  final List<Atividade> atividades;
  final void Function(BuildContext context, Atividade atividade) onAtividade;
  _CategoriaAtividade({
    Key? key,
    required this.atividades,
    required this.onAtividade,
  }) : super(
          key: key,
          categoria: 'Atividades',
          itens: List.generate(
            atividades.length,
            (index) {
              return Observer(builder: (context) {
                final atividade = atividades[index];
                final temaClube = Modular.get<TemaClube>();
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  title: Text(
                    atividade.titulo,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(atividade.descricao ?? ''),
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.task_outlined,
                      color: temaClube.textoEnfase,
                    ),
                    backgroundColor: temaClube.primaria.withOpacity(0.3),
                  ),
                  onTap: () => onAtividade(context, atividade),
                );
              });
            },
          ),
        );
}
