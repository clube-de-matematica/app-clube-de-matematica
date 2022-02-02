import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../../perfil/models/userapp.dart';
import '../../modules/atividades/models/argumentos_atividade_page.dart';
import '../../modules/atividades/models/atividade.dart';
import '../../shared/models/clube.dart';
import '../../shared/models/usuario_clube.dart';
import '../../shared/utils/interface_clube_controller.dart';

/// Uma enumeração para os itens do menu de opções dos clubes.
enum OpcoesUsuarioClube {
  promoverAdmin,
  removerAdmin,
  sairAdmin,
  remover,
  sair,
}

class ClubeController extends IClubeController
    with IClubeControllerMixinShowPageEditar, IClubeControllerMixinSairExcluir
    implements Disposable {
  ClubeController(this.clube) {
    _assinar();
  }

  late StreamSubscription _assinaturaAtividades;

  StreamSubscription _assinar() {
    try {
      _assinaturaAtividades.cancel();
    } catch (_) {
      // Caso _assinaturaAtividades não tenha sido inicializado;
    }
    return _assinaturaAtividades =
        repository.atividades(clube).listen((atividades) {
      clube.atividades
        ..removeAll(clube.atividades.difference(atividades.toSet()))
        ..addAll(atividades);
    });
  }

  Future<void> sincronizarAtividades() => repository.sincronizarClubes();

  final Clube clube;

  /// O [UsuarioClube] correspondente ao usuário atual do aplicativo para [clube].
  UsuarioClube get usuarioApp => clube.getUsuario(UserApp.instance.id!)!;

  List<Atividade> _atividades = [];

  ObservableList<Atividade> get atividades {
    final lista = clube.atividades.toList();
    if (lista.isEmpty && _atividades.isNotEmpty) {
      // Ocorre quando o clube é mesclado.
      _assinar();
    }
    _atividades = lista;
    return lista.asObservable();
  }

  @override
  Future<bool> abrirPaginaEditarClube(BuildContext context, [Clube? clube]) {
    return super.abrirPaginaEditarClube(context, clube ?? this.clube);
  }

  /// Abre a página para criar uma nova atividade.
  void abrirPaginaCriarAtividade(BuildContext context) {
    Navegacao.abrirPagina(context, RotaPagina.criarAtividade,
        argumentos: clube);
  }

  /// Abre a página para [atividade].
  void abrirPaginaAtividade(BuildContext context, Atividade atividade) {
    Navegacao.abrirPagina(
      context,
      RotaPagina.atividade,
      argumentos: ArgumentosAtividadePage(
        clube: clube,
        atividade: atividade,
      ),
    );
  }

  @override
  Future<bool> sair([Clube? clube]) async {
    return super.sair(clube ?? this.clube);
  }

  @override
  Future<bool> excluir([Clube? clube]) async {
    return super.excluir(clube ?? this.clube);
  }

  /// Define [usuario] como administrador de [clube].
  Future<bool> promoverAdmin(UsuarioClube usuario) async {
    if (!usuarioApp.proprietario) return false;
    if (usuario.administrador) return true;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuario,
      permissao: PermissoesClube.administrador,
    );
  }

  /// Remove [usuarioApp] da lista de administradores de [clube].
  Future<bool> sairAdmin() async {
    if (usuarioApp.membro) return true;
    if (!usuarioApp.administrador) return false;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuarioApp,
      permissao: PermissoesClube.membro,
    );
  }

  /// Remove [usuario] da lista de administradores de [clube].
  Future<bool> removerAdmin(UsuarioClube usuario) async {
    if (!usuarioApp.proprietario) return false;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuario,
      permissao: PermissoesClube.membro,
    );
  }

  /// Remove [usuario] de [clube].
  Future<bool> remover(UsuarioClube usuario) async {
    if (usuarioApp.proprietario || usuarioApp.administrador) {
      return repository.removerDoClube(clube, usuario);
    }
    return false;
  }

  @override
  void dispose() {
    _assinaturaAtividades.cancel();
    //super.dipose();
  }
}
