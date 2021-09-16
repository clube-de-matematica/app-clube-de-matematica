import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/perfil/models/userapp.dart';
import '../../modules/perfil/perfil_module.dart';
import '../../modules/perfil/widgets/avatar.dart';
import '../repositories/firebase/auth_repository.dart';
import '../utils/constantes.dart';
import 'myWillPopScope.dart';

/// Indica a página em que [MyDrawer] está sendo exibido.
enum MyDrawerPage { quiz, clubes }

///Um [Scaffold] com o [Drawer] do aplicativo.
class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.page = MyDrawerPage.clubes,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final MyDrawerPage page;

  ///Usuário do aplicativo.
  UserApp get user => Modular.get<UserApp>();

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final VoidCallback loadProfile = () async {
      bool result = true;
      if (widget.user.isAnonymous) {
        result = (await widget.user.signInWithGoogle()) == StatusSignIn.success;
      }
      if (result) {
        Navigator.of(context).pushNamed(PerfilModule.kAbsoluteRoutePerfilPage);
      }
    };

    final drawerHeader = AnimatedBuilder(
      animation: widget.user,
      builder: (_, __) {
        final accountName = widget.user.isAnonymous
            ? GestureDetector(
                child: const Text('Entre com sua conta'),
                onTap: loadProfile,
              )
            : Text(widget.user.name ?? '');

        final currentAccountPicture = GestureDetector(
          onTap: loadProfile,
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

    final drawerItems = ListView(
      padding: EdgeInsets.zero,
      children: [
        drawerHeader,
        if (widget.page == MyDrawerPage.quiz)
          ListTile(
            title: Text('Clubes'),
            leading: const Icon(Icons.groups),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        if (widget.page == MyDrawerPage.clubes)
          for (var i in _buildClubes(context)) i,
        if (widget.page == MyDrawerPage.clubes) const Divider(thickness: 1.5),
        if (widget.page == MyDrawerPage.clubes)
          ListTile(
            title: Text('Questões'),
            leading: const Icon(Icons.quiz_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ListTile(
          title: Text('Favoritos'),
          leading: const Icon(Icons.favorite_outline),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Downloads'),
          leading: const Icon(Icons.download_outlined),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(thickness: 1.5),
        ListTile(
          title: Text('Configurações'),
          leading: const Icon(Icons.settings_outlined),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Sobre'),
          leading: Icon(Icons.info_outlined),
          onTap: () {
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      body: MyWillPopScope(child: widget.body ?? SizedBox()),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: Drawer(
        child: drawerItems,
      ),
      onDrawerChanged: widget.onDrawerChanged,
      endDrawer: widget.endDrawer,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      restorationId: widget.restorationId,
    );
  }

  List<Widget> _buildClubes(BuildContext context) {
    return [
      ListTile(
        title: Text('Clube 1'),
        subtitle: Text('Administrador'),
        leading: CircleAvatar(),
        //dense: true,
      ),
      //const Divider(thickness: 1.5, height: 1.0),
      ListTile(
        title: Text('Clube 2'),
        subtitle: Text('Membro'),
        leading: CircleAvatar(),
        //dense: true,
      ),
    ];
  }
}