import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/utils/random_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'adicionar_clube_controller.g.dart';

class AdicionarClubeController = _CriarClubeControllerBase
    with _$CriarClubeController;

abstract class _CriarClubeControllerBase with Store {
  String? nome;
  String? descricao;
  Color cor = RandomColor();
  bool privado = false;
  String? validarNome(String? valor) {}
  Future<void> participar(BuildContext context, String codigo) async {}
  Future<void> criar(
    BuildContext context,
    String nome,
    String? descricao,
    Color corTema,
    bool privado,
  ) async {}
}
