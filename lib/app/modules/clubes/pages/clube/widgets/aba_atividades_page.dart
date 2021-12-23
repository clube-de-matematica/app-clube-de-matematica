import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../modules/atividades/models/atividade.dart';
import '../../../shared/utils/tema_clube.dart';
import '../clube_controller.dart';
import 'categoria.dart';

/// A subpágina exibida na aba "Atividades" da página do [clube].
class AtividadesPage extends StatelessWidget {
  const AtividadesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final temaClube = Modular.get<TemaClube>();
    final controle = Modular.get<ClubeController>();
    final clube = controle.clube;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: clube.capa,
        child: Icon(
          Icons.add,
          color: temaClube.textoPrimaria,
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
                  title: Text(
                    atividade.titulo,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(atividade.descricao ?? ''),
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.task_outlined,
                      color: Modular.get<TemaClube>().texto,
                    ),
                    backgroundColor: cor.withOpacity(0.3),
                  ),
                  onTap: () => Modular.get<ClubeController>()
                      .abrirPaginaAtividade(context, atividade),
                );
              });
            },
          ),
        );
}
