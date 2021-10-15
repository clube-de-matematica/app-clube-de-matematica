import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/clubes/shared/models/clube.dart';
import '../../modules/clubes/shared/repositories/clubes_repository.dart';
import '../../modules/perfil/models/userapp.dart';
import '../../modules/perfil/widgets/avatar.dart';
import '../../navigation.dart';
import '../repositories/interface_auth_repository.dart';
import '../utils/constantes.dart';
import 'appWillPopScope.dart';

/// Indica a página em que [ScaffoldWithDrawer] está sendo exibido.
enum AppDrawerPage { quiz, clubes }

/// Um [Scaffold] com o [Drawer] e o [WillPopScope] do aplicativo.
class ScaffoldWithDrawer extends Scaffold {
  ScaffoldWithDrawer({
    Key? key,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    //FloatingActionButtonLocation? floatingActionButtonLocation,
    //FloatingActionButtonAnimator? floatingActionButtonAnimator,
    //List<Widget>? persistentFooterButtons,
    //Widget? drawer,
    //void Function(bool)? onDrawerChanged,
    //Widget? endDrawer,
    //void Function(bool)? onEndDrawerChanged,
    Widget? bottomNavigationBar,
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
          key: key,
          appBar: appBar,
          body: AppWillPopScope(child: body ?? SizedBox()),
          floatingActionButton: floatingActionButton,
          drawer: _AppDrawer(page: page),
          bottomNavigationBar: bottomNavigationBar,
        );
}

/// O [Drawer] do aplicativo.
class _AppDrawer extends StatefulWidget {
  const _AppDrawer({
    Key? key,
    this.page = AppDrawerPage.quiz,
  }) : super(key: key);

  final AppDrawerPage page;

  /// Lista com os clubes do usuário.
  List<Clube> get clubes => Modular.get<ClubesRepository>().clubes;

  /// Usuário do aplicativo.
  UserApp get user => Modular.get<UserApp>();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<_AppDrawer> {
  /// Abre a página correspondente aos parâmetros dados.
  showPage<T extends Object?>(
    BuildContext context,
    RoutePage route, {
    String? routeName,
    Object? arguments,
    T? result,
    bool popDrawer = true,
  }) {
    if (popDrawer) Navigator.of(context).pop();
    return Navigation.showPage<T>(
      context,
      route,
      routeName: routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Abre a oágina de perfil, solicitando o login, caso este ainda não tenha ocorrido.
  void _loadProfile(BuildContext context) async {
    bool result = true;
    if (widget.user.isAnonymous) {
      result = (await Modular.get<IAuthRepository>().signInWithGoogle()) ==
          StatusSignIn.success;
    }
    if (result) {
      showPage(context, RoutePage.perfil);
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
            child: Avatar(widget.user),
            transitionOnUserGestures: true,
          ),
        );

        return UserAccountsDrawerHeader(
          accountName: accountName,
          accountEmail: Text(widget.user.email ?? ''),
          currentAccountPicture: currentAccountPicture,
        );
      },
    );

    final drawerItems = Observer(builder: (_) {
      final clubes = _buildClubes(context);
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader,
          //if (widget.page == MyDrawerPage.quiz)
          if (!widget.user.isAnonymous)
            ListTile(
              title: Text('Clubes'),
              leading: const Icon(Icons.groups),
              onTap: () => showPage(context, RoutePage.homeClubes),
            ),
          //if (widget.page == MyDrawerPage.clubes)
          for (var clube in clubes) clube,
          if (clubes.isNotEmpty) const Divider(thickness: 1.5),
          if (widget.page == AppDrawerPage.clubes)
            ListTile(
              title: Text('Questões'),
              leading: const Icon(Icons.quiz_outlined),
              onTap: () => showPage(context, RoutePage.quiz),
            ),
          ListTile(
            title: Text('Favoritos 3'),
            leading: const Icon(Icons.favorite_outline),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Downloads'),
            leading: const Icon(Icons.download_outlined),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          const Divider(thickness: 1.5),
          ListTile(
            title: Text('Configurações'),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Sobre'),
            leading: Icon(Icons.info_outlined),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          const Divider(thickness: 1.5),
          const ListTile(
            title: Text('Versão: $APP_VERSION'),
            dense: true,
          ),
        ],
      );
    });

    return Drawer(child: drawerItems);
  }

  List<Widget> _buildClubes(BuildContext context) {
    final userId = widget.user.id;
    return widget.clubes.map((clube) {
      String subtitle;

      if (userId == clube.proprietario)
        subtitle = 'Proprietário';
      else if (clube.administradores.contains(userId))
        subtitle = 'Administrador';
      else
        subtitle = 'Membro';

      return ListTile(
        title: Text(clube.nome),
        subtitle: Text(subtitle),
        leading: CircleAvatar(backgroundColor: clube.capa),
        onTap: () {
          showPage(
            context,
            RoutePage.clube,
            routeName: '${RoutePage.homeClubes.name}/${clube.id}',
            arguments: clube,
          );
        },
        //dense: true,
      );
    }).toList();
  }
}

/* /// O botão para abrir o [Drawer] principal do aplicativo.
class ButtonMenuRootDrawer extends StatelessWidget {
  const ButtonMenuRootDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      iconSize: 24,
      onPressed: () => openRootDrawer(context),
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
} */
