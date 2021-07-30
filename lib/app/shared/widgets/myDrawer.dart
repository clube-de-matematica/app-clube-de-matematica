import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/perfil/models/userapp.dart';
import '../../modules/perfil/perfil_module.dart';
import '../../modules/perfil/widgets/avatar.dart';
import '../repositories/firebase/auth_repository.dart';
import 'myWillPopScope.dart';

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
        ListTile(
          title: Text('Clubes'),
          leading: const Icon(Icons.groups),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Questões'),
          leading: const Icon(Icons.quiz),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Favoritos'),
          leading: const Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          title: Text('Configurações'),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          title: Text('Sobre'),
          leading: Icon(Icons.info),
          onTap: () {
            Navigator.pop(context);
          },
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

  _buildAboutIcon(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = iconTheme.size;
    final double iconOpacity = iconTheme.opacity ?? 1.0;
    Color iconColor = iconTheme.color!;

    if (iconOpacity != 1.0)
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);

    return IconTheme(
      data: IconTheme.of(context),
      child: Container(
        width: iconSize == null ? null : iconSize - 4,
        height: iconSize == null ? null : iconSize - 4,
        padding: EdgeInsets.zero,
        child: Center(
          child: RichText(
            overflow: TextOverflow.visible, // Never clip.
            text: TextSpan(
              text: 'i',
              style: TextStyle(
                inherit: false,
                color: iconColor,
                fontSize: iconSize == null ? null : iconSize - 8,
                fontFamily: "Courgette",
                //fontFamily: icon!.fontFamily,
                //package: icon!.fontPackage,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: iconColor,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
