// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questoes_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestoesRepository on _QuestoesRepositoryBase, Store {
  Computed<List<Questao>>? _$questoesComputed;

  @override
  List<Questao> get questoes =>
      (_$questoesComputed ??= Computed<List<Questao>>(() => super.questoes,
              name: '_QuestoesRepositoryBase.questoes'))
          .value;

  final _$_questoesAtom = Atom(name: '_QuestoesRepositoryBase._questoes');

  @override
  ObservableList<Questao> get _questoes {
    _$_questoesAtom.reportRead();
    return super._questoes;
  }

  @override
  set _questoes(ObservableList<Questao> value) {
    _$_questoesAtom.reportWrite(value, super._questoes, () {
      super._questoes = value;
    });
  }

  final _$carregarQuestoesAsyncAction =
      AsyncAction('_QuestoesRepositoryBase.carregarQuestoes');

  @override
  Future<List<Questao>> carregarQuestoes() {
    return _$carregarQuestoesAsyncAction.run(() => super.carregarQuestoes());
  }

  final _$_carregarQuestaoReferenciadaAsyncAction =
      AsyncAction('_QuestoesRepositoryBase._carregarQuestaoReferenciada');

  @override
  Future<Questao?> _carregarQuestaoReferenciada(
      List<Map<String, dynamic>> dbQuestoesData,
      Map<String, dynamic> questaoReferenciadora) {
    return _$_carregarQuestaoReferenciadaAsyncAction.run(() => super
        ._carregarQuestaoReferenciada(dbQuestoesData, questaoReferenciadora));
  }

  final _$_QuestoesRepositoryBaseActionController =
      ActionController(name: '_QuestoesRepositoryBase');

  @override
  void _addInQuestoes(Questao questao) {
    final _$actionInfo = _$_QuestoesRepositoryBaseActionController.startAction(
        name: '_QuestoesRepositoryBase._addInQuestoes');
    try {
      return super._addInQuestoes(questao);
    } finally {
      _$_QuestoesRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questoes: ${questoes}
    ''';
  }
}
