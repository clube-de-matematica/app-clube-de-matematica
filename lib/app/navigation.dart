import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

import 'clube_de_matematica_module.dart';
import 'modules/clubes/clubes_module.dart';
import 'modules/clubes/modules/atividades/atividades_module.dart';
import 'modules/clubes/modules/atividades/pages/consolidar/consolidar_atividade_page.dart';
import 'modules/clubes/modules/atividades/pages/criar/criar_atividade_page.dart';
import 'modules/clubes/modules/atividades/pages/editar/editar_atividade_page.dart';
import 'modules/clubes/modules/atividades/pages/responder/reponder_atividade_page.dart';
import 'modules/clubes/pages/clube/clube_page.dart';
import 'modules/clubes/pages/criar/criar_clube_page.dart';
import 'modules/clubes/pages/editar/editar_clube_page.dart';
import 'modules/clubes/pages/home/home_clubes_page.dart';
import 'modules/filtros/filtros_module.dart';
import 'modules/filtros/pages/home/filtro_home_page.dart';
import 'modules/login/login_module.dart';
import 'modules/login/pages/login_page.dart';
import 'modules/perfil/page/perfil_page.dart';
import 'modules/perfil/perfil_module.dart';
import 'modules/quiz/pages/quiz/quiz_page.dart';
import 'modules/quiz/quiz_module.dart';
import 'shared/models/debug.dart';
import 'shared/models/exceptions/my_exception.dart';

/// Enumeração para as rotas dos módulos.
enum RotaModulo {
  /// Representa a rota para o módulo [ClubeDeMatematicaModule].
  clubeDeMatematica,

  /// Representa a rota para o módulo [QuizModule].
  quiz,

  /// Representa a rota para o módulo [FiltrosModule].
  filtros,

  /// Representa a rota para o módulo [LoginModule].
  login,

  /// Representa a rota para o módulo [PerfilModule].
  perfil,

  /// Representa a rota para o módulo [ClubesModule].
  clubes,

  /// Representa a rota para o módulo [AtividadesModule].
  atividades,
}

extension ExtensaoRotaModulo on RotaModulo {
  String get nome {
    switch (this) {
      case RotaModulo.clubeDeMatematica:
        return ClubeDeMatematicaModule.kAbsoluteRouteModule;
      case RotaModulo.quiz:
        return QuizModule.kAbsoluteRouteModule;
      case RotaModulo.filtros:
        return FiltrosModule.kAbsoluteRouteModule;
      case RotaModulo.login:
        return LoginModule.kAbsoluteRouteModule;
      case RotaModulo.perfil:
        return PerfilModule.kAbsoluteRouteModule;
      case RotaModulo.clubes:
        return ClubesModule.kAbsoluteRouteModule;
      case RotaModulo.atividades:
        return AtividadesModule.kAbsoluteRouteModule;
    }
  }
}

/// Enumeração para as rotas das páginas.
enum RotaPagina {
  /// Representa a rota para a página [QuizPage].
  quiz,

  /// Representa a rota para a página [FiltroHomePage].
  filtros,

  /// Representa a rota para a página [LoginPage].
  login,

  /// Representa a rota para a página [PerfilPage].
  perfil,

  /// Representa a rota para a página [HomeClubesPage].
  homeClubes,

  /// Representa a rota para a página [ClubePage].
  clube,

  /// Representa a rota para a página [CriarClubePage].
  criarClube,

  /// Representa a rota para a página [EditarClubePage].
  editarClube,

  /// Representa a rota para a página [ResponderAtividadePage] ou [ConsolidarAtividadePage],
  /// dependendo da permissão do usuário.
  atividade,

  /// Representa a rota para a página [CriarAtividadePage].
  criarAtividade,

  /// Representa a rota para a página [EditarAtividadePage].
  editarAtividade,
}

extension ExtensaoRotaPagina on RotaPagina {
  String get nome {
    switch (this) {
      case RotaPagina.quiz:
        return QuizModule.kAbsoluteRouteQuizPage;
      case RotaPagina.filtros:
        return FiltrosModule.kAbsoluteRouteFiltroHomePage;
      case RotaPagina.login:
        return LoginModule.kAbsoluteRouteLoginPage;
      case RotaPagina.perfil:
        return PerfilModule.kAbsoluteRoutePerfilPage;
      case RotaPagina.homeClubes:
        return ClubesModule.kAbsoluteRouteHomePage;
      case RotaPagina.criarClube:
        return ClubesModule.kAbsoluteRouteCriarPage;
      case RotaPagina.editarClube:
        return ClubesModule.kAbsoluteRouteEditarPage;
      case RotaPagina.atividade:
        return AtividadesModule.kAbsoluteRouteAtividadePage;
      case RotaPagina.criarAtividade:
        return AtividadesModule.kAbsoluteRouteCriarPage;
      case RotaPagina.editarAtividade:
        return AtividadesModule.kAbsoluteRouteEditarPage;
      case RotaPagina.clube:
        throw MyException(
            'RotaPagina.clube não possui um nome estático, pois representa uma rota dinâmica.');
    }
  }

  /// Verdadeiro para os valores de [RotaPagina] que representam rotas dinamicas.
  bool get dinamica => this == RotaPagina.clube;

  /// Falso para os valores de [RotaPagina] que representam páginas que devem ser fechadas
  /// sempre que uma nova página for aberta.
  bool get empilhavel {
    switch (this) {
      case RotaPagina.quiz:
      case RotaPagina.filtros:
      case RotaPagina.homeClubes:
      case RotaPagina.clube:
      case RotaPagina.atividade:
      case RotaPagina.criarAtividade:
        return true;
      case RotaPagina.login:
      case RotaPagina.perfil:
      case RotaPagina.criarClube:
      case RotaPagina.editarClube:
      case RotaPagina.editarAtividade:
        return false;
    }
  }
}

abstract class Navegacao {
  /// Lista com os nomes das rotas das páginas empilhadas.
  static List<String?> paginas(BuildContext context) {
    return Navigator.of(context).widget.pages.map((pagina) {
      String? nome;
      // Incluído após uma atualização do Modular.
      final list = pagina.name?.split('@');
      if (list != null) {
        final nomeTemp = list[0];
        nome = nomeTemp;
      }
      return nome;
    }).toList();
  }

  /// Penúltima página da pilha.
  static String? paginaAnterior(BuildContext context) {
    final paginas = Navegacao.paginas(context);
    return paginas.length < 2 ? null : paginas[paginas.length - 2];
  }

  /// Última página da pilha.
  static String? paginaAtual(BuildContext context) {
    final paginas = Navegacao.paginas(context);
    return paginas.isEmpty ? null : paginas[paginas.length - 1];
  }

  static bool Function(Route<dynamic>) _haRotaComNome(String nome) {
    return (Route rota) {
      if (ModalRoute.withName(nome)(rota)) return true;
      return ModalRoute.withName('$nome/')(rota);
    };
  }

  /// Normaliza [rota], simplificando-o ao manipular .., e ., e removendo separadores de caminho redundantes sempre que possível.
  ///
  /// Se [rota] terminar com /, o caractere será mantido.
  static String _normalizar(String rota) {
    if (rota.isEmpty) {
      return rota;
    } else {
      String terminacao = rota[rota.length - 1];
      if (terminacao != '/') {
        terminacao = '';
      }
      final normal = "${path.normalize(rota)}$terminacao";
      return normal;
    }
  }

  /// Retorna verdadeiro se [rota] é o nome da rota para a página de algum clube.
  static bool _ePaginaClube(String rota) {
    if (rota.isEmpty) {
      return false;
    } else {
      final exp = RegExp(r'^' + RotaPagina.homeClubes.nome + r'\d+');

      /// Verificar se [rota] inicia com o nome da rota da página inicial dos clubes seguido de uma sequência de dígitos (pelo menos um).
      final ePaginaClube = exp.hasMatch(rota);
      return ePaginaClube;
    }
  }

  /// Abre a página correspondente aos parâmetros dados.
  static Future<T?> abrirPagina<T extends Object?>(
    BuildContext context,
    RotaPagina rota, {
    String? nomeRota,
    Object? argumentos,
    T? retorno,
  }) async {
    assert(!(rota.dinamica && nomeRota == null));
    assert(nomeRota == null || nomeRota.isNotEmpty);

    if (!rota.dinamica) nomeRota = rota.nome;
    final navegador = Navigator.of(context);
    final paginas = Navegacao.paginas(context);
    final paginaAnterior = Navegacao.paginaAnterior(context);
    final paginaAtual = Navegacao.paginaAtual(context);
    final novaPagina = _normalizar(nomeRota!);
    final paginaAtualEClube = _ePaginaClube(paginaAtual ?? '');

    if (novaPagina != paginaAtual) {
      if (novaPagina == RotaPagina.login.nome) {
        return navegador.pushNamedAndRemoveUntil<T>(
          novaPagina,
          (_) => false,
          arguments: argumentos,
        );
      }
      // Se a nova página está na pilha e é a anterior.
      if (novaPagina == paginaAnterior) {
        navegador.pop(retorno);
        return null;
      }
      // Se a nova página está na pilha mas não é a anterior.
      else if (paginas.contains(novaPagina)) {
        navegador.popUntil(_haRotaComNome(novaPagina));
        return null;
      }
      //
      else if (paginaAtual == RotaPagina.quiz.nome) {
        return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
      }
      // Se a página atual é não empilhável (não deve ser posta sob outra).
      else if (paginaAtual != null &&
          !(_buscarRotaPagina(paginaAtual)?.empilhavel ?? true)) {
        return navegador.pushReplacementNamed<T, dynamic>(novaPagina,
            arguments: argumentos, result: retorno);
      }
      //
      else {
        switch (rota) {
          case RotaPagina.login:
            return navegador.pushNamedAndRemoveUntil<T>(
              novaPagina,
              (_) => false,
              arguments: argumentos,
            );
          case RotaPagina.quiz:
            // Se a nova página é a de questões (página do quiz) e não está na pilha.
            return navegador.pushNamedAndRemoveUntil<T>(
              novaPagina,
              (_) => false,
              arguments: argumentos,
            );
          case RotaPagina.filtros:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.perfil:
            if (paginaAtual == RotaPagina.login.nome) {
              return navegador.pushReplacementNamed<T, dynamic>(novaPagina,
                  arguments: argumentos, result: retorno);
            } else {
              return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
            }
          case RotaPagina.homeClubes:
            if (paginaAtualEClube) {
              // Se a página atual for de um clube.
              return navegador.pushReplacementNamed<T, dynamic>(novaPagina,
                  arguments: argumentos, result: retorno);
            }
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.clube:
            if (paginaAtualEClube) {
              // Se a página atual for de um clube.
              /* navegador.pop(retorno);
              navegador.pushNamed(novaPagina, arguments: argumentos);
              return retorno; */
              return navegador.pushReplacementNamed<T, dynamic>(
                novaPagina,
                arguments: argumentos,
                result: retorno,
              );
            }
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.criarClube:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.editarClube:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.atividade:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.criarAtividade:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
          case RotaPagina.editarAtividade:
            return navegador.pushNamed<T>(novaPagina, arguments: argumentos);
        }
      }
    }
    return null;
  }

  /// Retorna o valor de [RotaPagina] correspondente a [nome].
  /// Se nenhum valor correspondente for encontrado, retorna `null`.
  static RotaPagina? _buscarRotaPagina(String nome) {
    try {
      return RotaPagina.values.where((e) => !e.dinamica).firstWhere(
        (e) => e.nome == nome,
        orElse: () {
          if (_ePaginaClube(nome)) {
            return RotaPagina.clube;
          }
          throw 'Não foi encontrada uma Rota de página correspondente à "$nome".';
        },
      );
    } catch (e) {
      assert(Debug.print(e));
      return null;
    }
  }
}
