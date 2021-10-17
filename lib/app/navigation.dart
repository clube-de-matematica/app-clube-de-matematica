import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'clube_de_matematica_module.dart';
import 'modules/clubes/clubes_module.dart';
import 'modules/clubes/pages/clube/clube_page.dart';
import 'modules/clubes/pages/adicionar/adicionar_clube_page.dart';
import 'modules/clubes/pages/editar/editar_clube_page.dart';
import 'modules/clubes/pages/home/home_clubes_page.dart';
import 'modules/filtros/filtros_module.dart';
import 'modules/filtros/pages/opcoes/filtro_opcoes_page.dart';
import 'modules/filtros/pages/tipos/filtro_tipos_page.dart';
import 'modules/login/login_module.dart';
import 'modules/login/pages/login_page.dart';
import 'modules/perfil/page/perfil_page.dart';
import 'modules/perfil/perfil_module.dart';
import 'modules/quiz/pages/quiz/quiz_page.dart';
import 'modules/quiz/quiz_module.dart';
import 'shared/models/debug.dart';
import 'shared/models/exceptions/my_exception.dart';

/// Enumeração para as rotas dos módulos.
enum RouteModule {
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
}

extension RouteModuleExtension on RouteModule {
  String get name {
    switch (this) {
      case RouteModule.clubeDeMatematica:
        return ClubeDeMatematicaModule.kAbsoluteRouteModule;
      case RouteModule.quiz:
        return QuizModule.kAbsoluteRouteModule;
      case RouteModule.filtros:
        return FiltrosModule.kAbsoluteRouteModule;
      case RouteModule.login:
        return LoginModule.kAbsoluteRouteModule;
      case RouteModule.perfil:
        return PerfilModule.kAbsoluteRouteModule;
      case RouteModule.clubes:
        return ClubesModule.kAbsoluteRouteModule;
    }
  }
}

/// Enumeração para as rotas das páginas.
enum RoutePage {
  /// Representa a rota para a página [QuizPage].
  quiz,

  /// Representa a rota para a página [FiltroTiposPage].
  filtrosTipos,

  /// Representa a rota para a página [FiltroOpcoesPage].
  filtrosOpcoes,

  /// Representa a rota para a página [LoginPage].
  login,

  /// Representa a rota para a página [PerfilPage].
  perfil,

  /// Representa a rota para a página [HomeClubesPage].
  homeClubes,

  /// Representa a rota para a página [ClubePage].
  clube,

  /// Representa a rota para a página [AdicionarClubePage].
  adicionarClube,

  /// Representa a rota para a página [EditarClubePage].
  editarClube,
}

extension RoutePageExtension on RoutePage {
  String get name {
    switch (this) {
      case RoutePage.quiz:
        return QuizModule.kAbsoluteRouteQuizPage;
      case RoutePage.filtrosTipos:
        return FiltrosModule.kAbsoluteRouteFiltroTiposPage;
      case RoutePage.filtrosOpcoes:
        return FiltrosModule.kAbsoluteRouteFiltroOpcoesPage;
      case RoutePage.login:
        return LoginModule.kAbsoluteRouteLoginPage;
      case RoutePage.perfil:
        return PerfilModule.kAbsoluteRoutePerfilPage;
      case RoutePage.homeClubes:
        return ClubesModule.kAbsoluteRouteHomePage;
      case RoutePage.adicionarClube:
        return ClubesModule.kAbsoluteRouteCriarPage;
      case RoutePage.editarClube:
        return ClubesModule.kAbsoluteRouteEditarPage;
      case RoutePage.clube:
        throw MyException(
            'RoutePage.clube não possui um nome estático, pois representa uma rota dinâmica.');
    }
  }

  /// Verdadeiro para os valores de [RoutePage] que representam rotas dinamicas.
  bool get isDynamic {
    switch (this) {
      case RoutePage.quiz:
      case RoutePage.filtrosTipos:
      case RoutePage.filtrosOpcoes:
      case RoutePage.login:
      case RoutePage.perfil:
      case RoutePage.homeClubes:
      case RoutePage.adicionarClube:
      case RoutePage.editarClube:
        return false;
      case RoutePage.clube:
        return true;
    }
  }

  /// Falso para os valores de [RoutePage] que representam páginas que devem ser fechadas
  /// sempre que uma nova página for aberta.
  bool get isStackable {
    switch (this) {
      case RoutePage.quiz:
      case RoutePage.filtrosTipos:
      case RoutePage.homeClubes:
      case RoutePage.clube:
        return true;
      case RoutePage.filtrosOpcoes:
      case RoutePage.login:
      case RoutePage.perfil:
      case RoutePage.adicionarClube:
      case RoutePage.editarClube:
        return false;
    }
  }
}

abstract class Navigation {
  /// Lista com os nomes das páginas empilhadas.
  static List<String?> pages(BuildContext context) {
    return Navigator.of(context)
        .widget
        .pages
        .map((page) => page.name?.replaceFirst('/', '', page.name!.length - 1))
        .toList();
  }

  /// Penúltima página da pilha.
  static String? previousPage(BuildContext context) {
    final _pages = pages(context);
    return _pages.length < 2 ? null : _pages[_pages.length - 2];
  }

  /// Última página da pilha.
  static String? currentPage(BuildContext context) {
    final _pages = pages(context);
    return _pages.isEmpty ? null : _pages[_pages.length - 1];
  }

  static bool Function(Route<dynamic>) _routeWithName(String name) {
    return (Route route) {
      if (ModalRoute.withName(name)(route)) return true;
      return ModalRoute.withName('$name/')(route);
    };
  }

  /// Abre a página correspondente aos parâmetros dados.
  static showPage<T extends Object?>(
    BuildContext context,
    RoutePage route, {
    String? routeName,
    Object? arguments,
    T? result,
  }) {
    assert(!(route.isDynamic && routeName == null));

    if (!route.isDynamic) routeName = route.name;
    final navigator = Navigator.of(context);
    final pages = Navigation.pages(context);
    final previousPage = Navigation.previousPage(context);
    final currentPage = Navigation.currentPage(context);
    final newPage = routeName!;
    final currentPageIsClube =
        currentPage?.startsWith('${RoutePage.homeClubes.name}/') ?? false;

    if (newPage != currentPage) {
      // Se a nova página está na pilha e é a anterior.
      if (newPage == previousPage) {
        return navigator.pop(result);
      }
      // Se a nova página está na pilha mas não é a anterior.
      else if (pages.contains(newPage)) {
        return navigator.popUntil(_routeWithName(newPage));
      }
      //
      else if (currentPage == RoutePage.quiz.name) {
        return navigator.pushNamed(newPage, arguments: arguments);
      }
      // Se a página atual é não empilhável (não deve ser posta sob outra).
      else if (currentPage != null &&
          !(_getRoutePage(currentPage)?.isStackable ?? true)) {
        return navigator.pushReplacementNamed(newPage,
            arguments: arguments, result: result);
      }
      //
      else {
        switch (route) {
          case RoutePage.quiz:
            // Se a nova página é a de questões (página do quiz) e não está na pilha.
            return navigator.pushNamedAndRemoveUntil(
              newPage,
              (_) => false,
              arguments: arguments,
            );
          case RoutePage.filtrosTipos:
            return navigator.pushNamed(newPage, arguments: arguments);
          case RoutePage.filtrosOpcoes:
            return navigator.pushNamed(newPage, arguments: arguments);
          case RoutePage.login:
            return navigator.pushNamedAndRemoveUntil(
              newPage,
              (_) => false,
              arguments: arguments,
            );
          case RoutePage.perfil:
            if (currentPage == RoutePage.login.name) {
              return navigator.pushReplacementNamed(newPage,
                  arguments: arguments, result: result);
            } else {
              return navigator.pushNamed(newPage, arguments: arguments);
            }
          case RoutePage.homeClubes:
            if (currentPageIsClube) {
              // Se a página atual for de um clube.
              return navigator.pushReplacementNamed(newPage,
                  arguments: arguments, result: result);
            }
            return navigator.pushNamed(newPage, arguments: arguments);
          case RoutePage.clube:
            if (currentPageIsClube) {
              // Se a página atual for de um clube.
              return navigator.pushReplacementNamed(newPage,
                  arguments: arguments, result: result);
            }
            return navigator.pushNamed(newPage, arguments: arguments);
          case RoutePage.adicionarClube:
            return navigator.pushNamed(newPage, arguments: arguments);
          case RoutePage.editarClube:
            return navigator.pushNamed(newPage, arguments: arguments);
          default:
            // TODO
            throw UnimplementedError('A rota $newPage não foi implementada.');
        }
      }
    }
  }

  /// Retorna o valor de [RoutePage] correspondente a [name].
  /// Se nenhum valor correspondente for encontrado, retorna `null`.
  static RoutePage? _getRoutePage(String name) {
    try {
      return RoutePage.values.where((e) => !e.isDynamic).firstWhere(
        (e) => e.name == name,
        orElse: () {
          if (name.startsWith('${RoutePage.homeClubes.name}/')) {
            return RoutePage.clube;
          }
          throw 'Não foi encontrado um RoutePage correspondente à rota "$name".';
        },
      );
    } catch (e) {
      assert(Debug.print(e));
      return null;
    }
  }
}
