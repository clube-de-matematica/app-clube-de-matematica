// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inserir_questao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InserirQuestaoController on _InserirQuestaoControllerBase, Store {
  final _$nivelAtom = Atom(name: '_InserirQuestaoControllerBase.nivel');

  @override
  int? get nivel {
    _$nivelAtom.reportRead();
    return super.nivel;
  }

  @override
  set nivel(int? value) {
    _$nivelAtom.reportWrite(value, super.nivel, () {
      super.nivel = value;
    });
  }

  final _$gabaritoAtom = Atom(name: '_InserirQuestaoControllerBase.gabarito');

  @override
  int? get gabarito {
    _$gabaritoAtom.reportRead();
    return super.gabarito;
  }

  @override
  set gabarito(int? value) {
    _$gabaritoAtom.reportWrite(value, super.gabarito, () {
      super.gabarito = value;
    });
  }

  final _$referenciaAtom =
      Atom(name: '_InserirQuestaoControllerBase.referencia');

  @override
  bool get referencia {
    _$referenciaAtom.reportRead();
    return super.referencia;
  }

  @override
  set referencia(bool value) {
    _$referenciaAtom.reportWrite(value, super.referencia, () {
      super.referencia = value;
    });
  }

  final _$nivelReferenciaAtom =
      Atom(name: '_InserirQuestaoControllerBase.nivelReferencia');

  @override
  int? get nivelReferencia {
    _$nivelReferenciaAtom.reportRead();
    return super.nivelReferencia;
  }

  @override
  set nivelReferencia(int? value) {
    _$nivelReferenciaAtom.reportWrite(value, super.nivelReferencia, () {
      super.nivelReferencia = value;
    });
  }

  final _$_InserirQuestaoControllerBaseActionController =
      ActionController(name: '_InserirQuestaoControllerBase');

  @override
  void limpar() {
    final _$actionInfo = _$_InserirQuestaoControllerBaseActionController
        .startAction(name: '_InserirQuestaoControllerBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$_InserirQuestaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nivel: ${nivel},
gabarito: ${gabarito},
referencia: ${referencia},
nivelReferencia: ${nivelReferencia}
    ''';
  }
}
