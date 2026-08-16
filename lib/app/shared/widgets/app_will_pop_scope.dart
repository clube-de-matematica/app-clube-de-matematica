import 'package:flutter/material.dart';

///Widget usado para notificar o usuário antes de fechar o aplicativo.
///Uma [SnackBar] é exibida para o usuário.
///[AppWillPopScope] deve estar na subárvore do corpo de um [Scaffold], caso contrário,
///`Scaffold.of()` em `_willPop()` lançará uma exceção.
class AppWillPopScope extends StatefulWidget {
  final Widget child;
  const AppWillPopScope({
    super.key,
    required this.child,
  });

  @override
  AppWillPopScopeState createState() => AppWillPopScopeState();
}

class AppWillPopScopeState extends State<AppWillPopScope> {
  final duration = const Duration(seconds: 2);

  int _backCounter = 0;

  bool _showSnackBar = false;

  _setBackCounter(int valor) {
    //Reiniciar o contador após a duração prédefinida.
    setState(() {
      _backCounter = valor;
    });
    Future.delayed(duration).whenComplete(() {
      if (valor != 0) {
        if (mounted) {
          setState(() {
            _backCounter = 0;
          });
        }
      }
    });
  }

  ///Retorna `true` se uma ação `pop` não implicar no fechamento do Aplicativo ou se uma segunda ação `pop` for emitida em até [duration].
  bool _willPop(BuildContext context) {
    _showSnackBar = false;
    //Se o drawer estiver aberto.
    if (Scaffold.of(context).isDrawerOpen) {
      return true;
    }
    //Se a rota atual não é a primeira da pilha.
    if (!(ModalRoute.of(context)?.isFirst ?? true)) {
      return true;
    }
    if (_backCounter >= 1) {
      return true;
    }
    _showSnackBar = true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool podeFechar = _willPop(context);
    return PopScope(
      canPop: podeFechar,
      onPopInvokedWithResult: (_,__) {
        // _ é o valor de canPop quando onPopInvokedWithResult é chamado.
        _setBackCounter(_backCounter + 1);
        if (_showSnackBar) {
          _showSnackBar = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: const Text('Pressione novamente para sair.'),
                  duration: duration,
                ),
              )
              .closed;
        }
      },
      child: widget.child,
    );
  }
}
