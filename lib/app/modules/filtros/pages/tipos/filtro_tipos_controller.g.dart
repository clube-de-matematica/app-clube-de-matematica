// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_tipos_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FiltroTiposController on _FiltroTiposControllerBase, Store {
  Computed<int> _$totalSelecinadoComputed;

  @override
  int get totalSelecinado =>
      (_$totalSelecinadoComputed ??= Computed<int>(() => super.totalSelecinado,
              name: '_FiltroTiposControllerBase.totalSelecinado'))
          .value;
  Computed<bool> _$ativarLimparComputed;

  @override
  bool get ativarLimpar =>
      (_$ativarLimparComputed ??= Computed<bool>(() => super.ativarLimpar,
              name: '_FiltroTiposControllerBase.ativarLimpar'))
          .value;

  final _$_FiltroTiposControllerBaseActionController =
      ActionController(name: '_FiltroTiposControllerBase');

  @override
  void limpar() {
    final _$actionInfo = _$_FiltroTiposControllerBaseActionController
        .startAction(name: '_FiltroTiposControllerBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$_FiltroTiposControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalSelecinado: ${totalSelecinado},
ativarLimpar: ${ativarLimpar}
    ''';
  }
}
