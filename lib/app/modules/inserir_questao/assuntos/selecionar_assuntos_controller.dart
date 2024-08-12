import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../services/db_servicos_interface.dart';
import '../../quiz/shared/models/assunto_model.dart';

part 'selecionar_assuntos_controller.g.dart';

class SelecionarAssuntosController = SelecionarAssuntosControllerBase
    with _$SelecionarAssuntosController;

abstract class SelecionarAssuntosControllerBase with Store {
  SelecionarAssuntosControllerBase(Iterable<ArvoreAssuntos> selecionados)
      : selecionados = ObservableSet.of(selecionados);

  IDbServicos get _dbService => Modular.get<IDbServicos>();

  /// Lista com todos os assuntos (incluindo as unidades) disponíveis.
  final _assuntosStream =
      Modular.get<IDbServicos>().obterAssuntos().asObservable();

  /// Lista com todos os assuntos disponíveis.
  @computed
  List<Assunto> get _assuntos {
    return _assuntosStream.value ?? [];
  }

  @computed
  List<ArvoreAssuntos> get arvores {
    List<ArvoreAssuntos> lista = [];
    final maxIndice = [
      0,
      ..._assuntos.map((assunto) => assunto.hierarquia.length),
    ].reduce((atual, proximo) => atual > proximo ? atual : proximo);
    int indice = maxIndice;

    while (indice >= 0) {
      final assuntosIndice =
          _assuntos.where((assunto) => assunto.hierarquia.length == indice);
      lista = assuntosIndice.map((assunto) {
        return ArvoreAssuntos(
          assunto: assunto,
          subAssuntos: lista
              .where((e) => e.assunto.hierarquia.last == assunto.id)
              .toList(),
        );
      }).toList();
      indice--;
    }
    return lista;
  }

  /// Conjunto com todos os assuntos selecionados.
  final ObservableSet<ArvoreAssuntos> selecionados;

  Computed<bool> selecionado(ArvoreAssuntos arvore) {
    return Computed<bool>(
        () => selecionados.any((e) => e.assunto.id == arvore.assunto.id));
  }

  Future<bool> inserirAssunto(String assunto, Assunto? pai) async {
    return _dbService.inserirAssunto(
      RawAssunto(
        titulo: assunto,
        hierarquia: pai == null ? [] : [...pai.hierarquia, pai.id],
      ),
    );
  }
}

extension OrdenarArvoresDesconsiderandoAcentos on List<ArvoreAssuntos> {
  void ordenarDesconsiderandoAcentos() {
    sort((a, b) => removeDiacritics(a.assunto.titulo)
        .compareTo(removeDiacritics(b.assunto.titulo)));
  }
}

class ArvoreAssuntos {
  ArvoreAssuntos({
    required this.assunto,
    this.subAssuntos = const [],
  });

  final Assunto assunto;
  final List<ArvoreAssuntos> subAssuntos;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArvoreAssuntos &&
        other.assunto == assunto &&
        listEquals(other.subAssuntos, subAssuntos);
  }

  @override
  int get hashCode => assunto.hashCode ^ subAssuntos.hashCode;
}
