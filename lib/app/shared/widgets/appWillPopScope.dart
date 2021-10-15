import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

///Widget usado para notificar o usuário antes de fechar o aplicativo.
///Uma [SnackBar] é exibida para o usuário.
///[AppWillPopScope] deve estar na subárvore do corpo de um [Scaffold], caso contrário,
///`Scaffold.of()` em `_onWillPop()` lançará uma exceção.
class AppWillPopScope extends StatefulWidget {
  final Widget child;
  const AppWillPopScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _AppWillPopScopeState createState() => _AppWillPopScopeState();
}

class _AppWillPopScopeState extends State<AppWillPopScope> {
  ThemeData get tema => AppTheme.instance.temaClaro;

  TextStyle? get textStyle => tema.textTheme.bodyText1;

  int backCounter = 0;

  ///Exibe uma [SnackBar] após uma ação `pop`.
  ///Retorna `true` se uma segunda ação `pop` for emitida em até 2 segundos.
  Future<bool> _onWillPop(BuildContext context) async {
    //Se o drawer estiver aberto.
    if (Scaffold.of(context).isDrawerOpen) return true;
    //Se a rota atual não é a primeira da pilha.
    if (!(ModalRoute.of(context)?.isFirst ?? true)) return true;
    
    final initTime = DateTime.now();
    final duration = const Duration(seconds: 2);
    backCounter += 1;
    if (backCounter >= 2) return true;
    await ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Pressione novamente para sair.',
              style: TextStyle(fontSize: textStyle?.fontSize),
            ),
            duration: duration,
          ),
        )
        .closed;
    //Reiniciar o contador após a duração prédefinida.
    if (DateTime.now().difference(initTime) > duration) {
      backCounter = 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: () => _onWillPop(context),
    );
  }
}
