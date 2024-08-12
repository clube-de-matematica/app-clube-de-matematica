import '../../pages/sobre_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/clubes/shared/models/clube.dart';
import '../../modules/clubes/shared/repositories/clubes_repository.dart';
import '../../modules/inserir_questao/inserir_questao_module.dart';
import '../../modules/perfil/models/userapp.dart';
import '../../modules/perfil/widgets/avatar.dart';
import '../../navigation.dart';
import '../../services/conectividade.dart';
import '../../services/db_servicos_interface.dart';
import '../repositories/interface_auth_repository.dart';
import '../theme/appTheme.dart';
import '../utils/constantes.dart';
import 'appBottomSheet.dart';
import 'appWillPopScope.dart';

/// Indica a página em que [ScaffoldWithDrawer] está sendo exibido.
enum AppDrawerPage { quiz, clubes }

/// Um [Scaffold] com o [Drawer] e o [PopScope] do aplicativo.
class ScaffoldWithDrawer extends Scaffold {
  ScaffoldWithDrawer({
    super.key,
    super.appBar,
    Widget? body,
    super.floatingActionButton,
    //FloatingActionButtonLocation? floatingActionButtonLocation,
    //FloatingActionButtonAnimator? floatingActionButtonAnimator,
    //List<Widget>? persistentFooterButtons,
    //Widget? drawer,
    //void Function(bool)? onDrawerChanged,
    //Widget? endDrawer,
    //void Function(bool)? onEndDrawerChanged,
    super.bottomNavigationBar,
    //Widget? bottomSheet,
    //Color? backgroundColor,
    //bool? resizeToAvoidBottomInset,
    //bool primary = true,
    //DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start,
    //bool extendBody = false,
    //bool extendBodyBehindAppBar = false,
    //Color? drawerScrimColor,
    //double? drawerEdgeDragWidth,
    //bool drawerEnableOpenDragGesture = true,
    //bool endDrawerEnableOpenDragGesture = true,
    //String? restorationId,
    AppDrawerPage page = AppDrawerPage.quiz,
  }) : super(
          body: AppWillPopScope(child: body ?? const SizedBox()),
          drawer: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: _AppDrawer(page: page),
            );
          }),
        );
}

/// O [Drawer] do aplicativo.
class _AppDrawer extends StatefulWidget {
  const _AppDrawer({
    this.page = AppDrawerPage.quiz,
  });

  final AppDrawerPage page;

  /// Usuário do aplicativo.
  UserApp get user => Modular.get<UserApp>();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<_AppDrawer> {
  /// Abre a página correspondente aos parâmetros dados.
  showPage<T extends Object?>(
    BuildContext context,
    RotaPagina route, {
    String? routeName,
    Object? arguments,
    T? result,
    bool popDrawer = true,
  }) {
    if (popDrawer) Navigator.of(context).pop();
    return Navegacao.abrirPagina<T>(
      context,
      route,
      nomeRota: routeName,
      argumentos: arguments,
      retorno: result,
    );
  }

  /// Abre a página de perfil, solicitando o login, caso este ainda não tenha ocorrido.
  void _loadProfile(BuildContext context) async {
    bool result = true;
    if (widget.user.isAnonymous) {
      if (!await Conectividade.instancia.verificar()) {
        if (context.mounted) {
          const BottomSheetErroConexao().showModal(context);
        }
        return;
      }
      result = (await Modular.get<IAuthRepository>().signInWithGoogle()) ==
          SignInChangeState.success;
    }
    if (result) {
      if (context.mounted) {
        showPage(context, RotaPagina.perfil);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = AnimatedBuilder(
      animation: widget.user,
      builder: (_, __) {
        final accountName = widget.user.isAnonymous
            ? GestureDetector(
                child: const Text('Entre com sua conta'),
                onTap: () => _loadProfile(context),
              )
            : Text(widget.user.name ?? '');

        final currentAccountPicture = GestureDetector(
          onTap: () => _loadProfile(context),
          child: Hero(
            tag: 'hero-avatar',
            transitionOnUserGestures: true,
            child: Avatar(widget.user),
          ),
        );

        return Theme(
          data: AppTheme.instance.light,
          child: UserAccountsDrawerHeader(
            accountName: accountName,
            accountEmail: Text(widget.user.email ?? ''),
            currentAccountPicture: currentAccountPicture,
          ),
        );
      },
    );

    final drawerItems = Observer(builder: (_) {
      final clubes = widget.user.isAnonymous
          ? <Widget>[]
          : _buildClubes(
              context,
              Modular.get<ClubesRepository>().clubes.toList(),
            );
      icone(IconData icon) {
        return AnimatedContainer(
          constraints: const BoxConstraints(
            maxWidth: 2 * kRadialReactionRadius,
            maxHeight: 2 * kRadialReactionRadius,
          ),
          duration: kThemeChangeDuration,
          child: Center(child: Icon(icon)),
        );
      }

      return ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader,
          if (!widget.user.isAnonymous)
            ListTile(
              title: const Text('Clubes'),
              leading: icone(Icons.groups),
              onTap: () => showPage(context, RotaPagina.homeClubes),
            ),
          ...clubes,
          if (clubes.isNotEmpty) const Divider(thickness: 1.5),
          //if (widget.page == AppDrawerPage.clubes)
          ListTile(
            title: const Text('Questões'),
            leading: icone(Icons.quiz_outlined),
            onTap: () => showPage(context, RotaPagina.quiz),
          ),
          FutureBuilder<bool>(
            future: Modular.get<IDbServicos>().checarPermissaoInserirQuestao(),
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data ?? false) {
                  return ListTile(
                    title: const Text('Inserir questão'),
                    leading: icone(Icons.add),
                    onTap: () => Navigator.of(context).pushNamed(
                        InserirQuestaoModule.kAbsoluteRouteInserirQuestaoPage),
                  );
                }
              }
              return const SizedBox();
            },
          ),
          /* 
          ListTile(
            title: Text('Favoritos'),
            leading: icone(Icons.favorite_outline),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Downloads'),
            leading: icone(Icons.download_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          */
          const Divider(thickness: 1.5),
          /* 
          ListTile(
            title: Text('Configurações'),
            leading: icone(Icons.settings_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          */
          ListTile(
            title: const Text('Sobre'),
            leading: icone(Icons.info_outlined),
            onTap: () async {
              // TODO: Navigator.push(context, MaterialPageRoute(builder: (_) => DbInspecaoPage()));
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SobrePage()),
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(thickness: 1.5),
          const Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  title: Text('Versão: $APP_VERSION'),
                  dense: true,
                ),
              ),
            ],
          ),
          //const SizedBox(height: 8.0),
        ],
      );
    });

    return Drawer(child: drawerItems);
  }

  List<Widget> _buildClubes(BuildContext context, List<Clube> clubes) {
    final userId = widget.user.id;
    return clubes.map((clube) {
      final usuario = userId == null ? null : clube.getUsuario(userId);
      String subtitle = '';

      if (usuario != null) {
        if (usuario.proprietario) {
          subtitle = 'Proprietário';
        } else if (usuario.administrador) {
          subtitle = 'Administrador';
        } else {
          subtitle = 'Membro';
        }
      }

      return ListTile(
        title: Text(clube.nome),
        subtitle: Text(subtitle),
        leading: CircleAvatar(backgroundColor: clube.capa),
        onTap: () {
          showPage(
            context,
            RotaPagina.clube,
            routeName: '${RotaPagina.homeClubes.nome}/${clube.id}',
            arguments: clube,
          );
        },
        //dense: true,
      );
    }).toList();
  }
}
