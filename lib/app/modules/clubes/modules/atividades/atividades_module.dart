import 'package:clubedematematica/app/modules/clubes/modules/atividades/pages/selecionar_questoes/selecionar_questoes_page.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../clubes_module.dart';
import 'pages/responder/reponder_atividade_page.dart';
import 'pages/criar/criar_atividade_page.dart';
import 'pages/editar/editar_atividade_page.dart';

class AtividadesModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/atividades";

  ///Rota absoluta.
  static const kAbsoluteRouteModule =
      ClubesModule.kAbsoluteRouteModule + kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteAtividadePage = '';

  ///Rota absoluta.
  static const kAbsoluteRouteAtividadePage =
      kAbsoluteRouteModule + kRelativeRouteAtividadePage;

  ///Rota relativa.
  static const kRelativeRouteCriarPage = '/nova';

  ///Rota absoluta.
  static const kAbsoluteRouteCriarPage =
      kAbsoluteRouteModule + kRelativeRouteCriarPage;

  ///Rota relativa.
  static const kRelativeRouteEditarPage = '/editar';

  ///Rota absoluta.
  static const kAbsoluteRouteEditarPage =
      kAbsoluteRouteModule + kRelativeRouteEditarPage;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        //Controles
        //Bind((i) => HomeClubesController()),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(kAbsoluteRouteAtividadePage,
            child: (_, args) => ResponderAtividadePage(args.data)),
        ChildRoute(kRelativeRouteCriarPage,
            child: (_, args) => CriarAtividadePage(args.data ??
            // TODO: Remover
                Clube(
                  id: 14,
                  nome: 'Quarto Clube',
                  proprietario: UsuarioClube(
                    id: 1,
                    idClube: 14,
                    permissao: PermissoesClube.administrador,
                    nome: 'Aluno de Desenvolvimento',
                    email: 'alunodedesenvolvimento@gmail.com',
                  ),
                  codigo: 'J5lSts',
                  privado: false,
                  descricao: 'Descrevendo o quarto clubes.',
                  capa: Color(4284513675),
                ))),
        ChildRoute(kRelativeRouteEditarPage,
            child: (_, args) => EditarAtividadePage(args.data)),
      ];
}
