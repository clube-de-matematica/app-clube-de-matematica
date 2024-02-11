import 'dart:ui';

import 'package:flutter/material.dart';

import '../../pages/sobre_page.dart' show mostrarPolitica, mostrarTemos;
import '../../services/preferencias_servicos.dart';
import 'botoes.dart';

/// Uma página exibida na parte inferior da tela.
/// A estrutura desse [Widget] é baseada na estrutura do [AlertDialog].
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    Key? key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.actionAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    this.clipBehavior,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
    ),
    this.transitionAnimationController,
    this.isScrollControlled = false,
    this.maximize = false,
    this.builder,
  }) : super(key: key);

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? contentTextStyle;
  final List<Widget>? actions;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment? actionAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final Color? backgroundColor;
  final double? elevation;
  final Clip? clipBehavior;
  final ShapeBorder shape;
  final AnimationController? transitionAnimationController;
  final bool isScrollControlled;
  final bool maximize;

  /// Usado para expor o [BuildContext] do construtor de [showModal] e [show].
  /// O [Widget] do parâmetro é o retorno de [AppBottomSheet.build].
  final Widget Function(BuildContext context, Widget child)? builder;

  /// Exibir bottom sheet modal.
  Future<T?> showModal<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      shape: shape,
      elevation: elevation,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      transitionAnimationController: transitionAnimationController,
      isScrollControlled: isScrollControlled,
      builder: (context) =>
          builder?.call(context, build(context)) ?? build(context),
    );
  }

  /// Exibir bottom sheet persistente.
  PersistentBottomSheetController<T> show<T>(BuildContext context) {
    return showBottomSheet<T>(
      context: context,
      shape: shape,
      elevation: elevation,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      transitionAnimationController: transitionAnimationController,
      builder: (context) =>
          builder?.call(context, build(context)) ?? build(context),
    );
  }

  Widget _buildDraggableScrollable(Widget child) {
    final media = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final altura = media.size.height;
    final maxChildSize =
        (altura - media.padding.top - kBottomNavigationBarHeight) / altura;
    return DraggableScrollableSheet(
      initialChildSize: maximize ? maxChildSize : 0.4,
      minChildSize: 0.2,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, controller) => _buildContainer(
        context: context,
        ancorar: true,
        child: Expanded(
          child: ListView(
            controller: controller,
            children: [
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({
    required BuildContext context,
    required Widget child,
    required bool ancorar,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);

    String? label = semanticLabel;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label ??= MaterialLocalizations.of(context).alertDialogLabel;
    }

    final anchor = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          width: 48.0,
          child: const Divider(
            height: 10.0,
            thickness: 3.0,
          ),
        ),
      ],
    );

    List<Widget> columnChildren;
    columnChildren = <Widget>[
      if (ancorar) anchor,
      child,
    ];

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );

    if (label != null)
      dialogChild = Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    return dialogChild;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);

    String? label = semanticLabel;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label ??= MaterialLocalizations.of(context).alertDialogLabel;
    }

    // The paddingScaleFactor is used to adjust the padding of Dialog's
    // children.
    final double paddingScaleFactor =
        _paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    Widget? titleWidget;
    Widget? contentWidget;
    Widget? actionsWidget;
    if (title != null) {
      final EdgeInsets defaultTitlePadding =
          EdgeInsets.fromLTRB(24.0, 14.0, 24.0, content == null ? 20.0 : 0.0);
      final EdgeInsets effectiveTitlePadding =
          titlePadding?.resolve(textDirection) ?? defaultTitlePadding;
      titleWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveTitlePadding.left * paddingScaleFactor,
          right: effectiveTitlePadding.right * paddingScaleFactor,
          top: effectiveTitlePadding.top * paddingScaleFactor,
          bottom: effectiveTitlePadding.bottom,
        ),
        child: DefaultTextStyle(
          style: titleTextStyle ??
              dialogTheme.titleTextStyle ??
              theme.textTheme.titleLarge ??
              TextStyle(),
          child: Semantics(
            namesRoute: label == null,
            container: true,
            child: title,
          ),
        ),
      );
    }

    if (content != null) {
      final EdgeInsets effectiveContentPadding =
          contentPadding.resolve(textDirection);
      contentWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveContentPadding.left * paddingScaleFactor,
          right: effectiveContentPadding.right * paddingScaleFactor,
          top: title == null
              ? effectiveContentPadding.top * paddingScaleFactor
              : effectiveContentPadding.top,
          bottom: effectiveContentPadding.bottom,
        ),
        child: DefaultTextStyle(
          style: contentTextStyle ??
              dialogTheme.contentTextStyle ??
              theme.textTheme.titleMedium!,
          child: Semantics(
            container: true,
            child: content,
          ),
        ),
      );
    }

    final divider = () => const Divider(height: 1.0);

    if (actions != null) {
      final double spacing = (buttonPadding?.horizontal ?? 0) / 2;
      final _children = <Widget>[];
      for (var i = 0; i < actions!.length; i++) {
        _children.add(SizedBox(
          height: 56.0,
          width: double.maxFinite,
          child: actions![i],
        ));
        //if (i < actions!.length - 1)
        _children.add(divider());
      }
      actionsWidget = Padding(
        padding: actionsPadding,
        child: Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.all(spacing),
          child: IntrinsicHeight(
            child: Column(
              children: _children,
            ),
            /* IntrinsicHeight(
              child: OverflowBar(
                alignment: actionAlignment,
                spacing: spacing,
                overflowAlignment: OverflowBarAlignment.end,
                overflowDirection:
                    actionsOverflowDirection ?? VerticalDirection.down,
                overflowSpacing: actionsOverflowButtonSpacing ?? 0,
                children: actions!,
              ),
            ), */
          ),
        ),
      );
    }

    List<Widget> columnChildren;
    columnChildren = <Widget>[
      if (title != null) titleWidget!,
      if (content != null) Flexible(child: contentWidget!),
      if (actions != null) divider(),
      if (actions != null) actionsWidget!,
    ];

    Widget columnChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    return isScrollControlled
        ? _buildDraggableScrollable(columnChild)
        : _buildContainer(context: context, child: columnChild, ancorar: true);
  }

  /// Copiado de [AlertDialog].
  double _paddingScaleFactor(double textScaleFactor) {
    final double clampedTextScaleFactor = textScaleFactor.clamp(1.0, 2.0);
    // The final padding scale factor is clamped between 1/3 and 1. For example,
    // a non-scaled padding of 24 will produce a padding between 24 and 8.
    return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
  }
}

/// Uma página inferior para exibir uma mensagem de erro [mensagem].
class BottomSheetErro extends AppBottomSheet {
  const BottomSheetErro(this.mensagem, {Key? key}) : super(key: key);
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: const Text('Falha na operação'),
      content: Text(mensagem),
      actions: [
        AppTextButton(
          primary: true,
          child: const Text('FECHAR'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

/// Uma página inferior para exibir quando o dispositivo estiver sem acesso a internete.
class BottomSheetErroConexao extends AppBottomSheet {
  const BottomSheetErroConexao({
    Key? key,
    this.rotuloAcao = 'FECHAR',
    this.acao,
  }) : super(key: key);

  final String rotuloAcao;
  final VoidCallback? acao;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: const Text('Falha na conexão'),
      content: const Text('Dispositivo sem acesso à internete.'),
      actions: [
        AppTextButton(
          primary: false,
          child: Text(rotuloAcao),
          onPressed: () {
            acao?.call();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Uma página inferior que exibe dois botões de ação.
/// Ao ser fechada, retorna:
/// * [resultActionFirst] se o primeiro botão for acionado;
/// * [resultActionLast] se o último botão for acionado; ou
/// * `null` nos demais casos.
class BottomSheetAcoes<T extends Object?> extends AppBottomSheet {
  const BottomSheetAcoes({
    Key? key,
    this.title,
    this.content,
    this.labelActionFirst = 'CONFIRMAR',
    this.labelActionLast = 'CANCELAR',
    this.actionFirstIsPrimary = true,
    this.actionLastIsPrimary = false,
    required this.resultActionFirst,
    required this.resultActionLast,
  }) : super(key: key);

  /// O título desta página inferior.
  final Widget? title;

  /// O conteúdo desta página inferior.
  final Widget? content;

  /// Texto do primeiro botão.
  final String labelActionFirst;

  /// Texto do último botão.
  final String labelActionLast;

  /// Se o primeiro botão é primário.
  final bool actionFirstIsPrimary;

  /// Se o último botão é primário.
  final bool actionLastIsPrimary;

  /// Retorno da página quando o primeiro botão é acionado.
  final T resultActionFirst;

  /// Retorno da página quando o último botão é acionado.
  final T resultActionLast;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      content: content,
      actions: [
        AppTextButton(
          primary: actionFirstIsPrimary,
          child: Text(labelActionFirst),
          onPressed: () => Navigator.pop<T>(context, resultActionFirst),
        ),
        AppTextButton(
          primary: actionLastIsPrimary,
          child: Text(labelActionLast),
          onPressed: () => Navigator.pop<T>(context, resultActionLast),
        ),
      ],
    );
  }
}

/// Uma página inferior para confirmar ou cancelar uma ação.
/// Ao ser fechada, retorna `true` se o usuário confirmar a ação.
class BottomSheetCancelarConfirmar extends BottomSheetAcoes<bool> {
  BottomSheetCancelarConfirmar({
    Key? key,
    Widget? title,
    Widget? content,
    String? message,
  })  : assert(!(content != null && message != null)),
        super(
          key: key,
          title: title,
          content: content ??
              (message == null
                  ? null
                  : Text(
                      message,
                      textAlign: TextAlign.justify,
                    )),
          labelActionFirst: 'CONFIRMAR',
          labelActionLast: 'CANCELAR',
          actionFirstIsPrimary: true,
          actionLastIsPrimary: false,
          resultActionFirst: true,
          resultActionLast: false,
        );
}

/// Uma página inferior para confirmar ou cancelar uma ação de sair.
/// Ao ser fechada, retorna `true` se o usuário confirmar a ação.
class BottomSheetCancelarSair extends BottomSheetAcoes<bool> {
  BottomSheetCancelarSair({
    Key? key,
    Widget? title,
    Widget? content,
    String? message,
  })  : assert(!(content != null && message != null)),
        super(
          key: key,
          title: title,
          content: content ??
              (message == null
                  ? null
                  : Text(
                      message,
                      textAlign: TextAlign.justify,
                    )),
          labelActionFirst: 'SAIR',
          labelActionLast: 'CANCELAR',
          actionFirstIsPrimary: false,
          actionLastIsPrimary: false,
          resultActionFirst: true,
          resultActionLast: false,
        );
}

/// Uma página inferior para confirmar ou cancelar uma ação de sair.
/// Inclui uma opção para salvar os dados modificados
/// Ao ser fechada, retorna:
/// * 0 se o usuário escolher cancelar;
/// * 1 se o usuário escolher sair; e
/// * 2 se o usuário escolher salvar.
class BottomSheetSalvarSairCancelar extends AppBottomSheet {
  BottomSheetSalvarSairCancelar({
    Key? key,
    Widget? title,
    Widget? content,
    String? message,
  })  : assert(!(content != null && message != null)),
        super(
          key: key,
          title: title,
          content: content ??
              (message == null
                  ? null
                  : Text(
                      message,
                      textAlign: TextAlign.justify,
                    )),
          actions: [
            Builder(builder: (context) {
              return AppTextButton(
                primary: true,
                child: const Text('SALVAR'),
                onPressed: () => Navigator.pop<int>(context, 2),
              );
            }),
            Builder(builder: (context) {
              return AppTextButton(
                primary: false,
                child: const Text('SAIR'),
                onPressed: () => Navigator.pop<int>(context, 1),
              );
            }),
            Builder(builder: (context) {
              return AppTextButton(
                primary: false,
                child: const Text('CANCELAR'),
                onPressed: () => Navigator.pop<int>(context, 0),
              );
            }),
          ],
        );
}

/// Uma página inferior que exibe um [CircularProgressIndicator].
/// Retorna o resultado de [future].
class BottomSheetCarregando extends AppBottomSheet {
  const BottomSheetCarregando({
    Key? key,
    this.title,
    required this.future,
  }) : super(key: key);

  final Widget? title;
  final Future future;

  @override
  Widget build(BuildContext context) {
    return _ChildBottomSheetCarregando(
      future: future,
      title: title,
    );
  }
}

class _ChildBottomSheetCarregando extends StatefulWidget {
  const _ChildBottomSheetCarregando({
    Key? key,
    this.title,
    required this.future,
  }) : super(key: key);

  final Widget? title;
  final Future future;

  @override
  __ChildBottomSheetCarregandoState createState() =>
      __ChildBottomSheetCarregandoState();
}

class __ChildBottomSheetCarregandoState
    extends State<_ChildBottomSheetCarregando> {
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: widget.title,
      content: FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          final size = 56.0;
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(Duration(seconds: 1)).then((_) {
              if (mounted && Navigator.canPop(context))
                Navigator.pop(context, snapshot.data);
            });
          }
          return Container(
            alignment: Alignment.center,
            height: size,
            child: SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: Colors.black26,
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomSheetAvisoConsentimento extends AppBottomSheet {
  BottomSheetAvisoConsentimento({Key? key})
      : super(
          isScrollControlled: true,
          maximize: true,
          content: Builder(builder: (context) {
            try {
              Preferencias.instancia.aceiteTermosCondicoesPolitica =
                  DateTime.now();
            } catch (_) {}
            bool naoReexibir = false;
            return Column(
              children: [
                Text(
                  'Ao utilizar este aplicativo você concorda com os Termos e Condições '
                  'de uso e com a Política de Privacidade acessíveis na opção "Sobre" '
                  'do menu principal.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18),
                ),
                SizedBox(height: 16.0),
                StatefulBuilder(builder: ((_, setState) {
                  return CheckboxListTile(
                    value: naoReexibir,
                    contentPadding: EdgeInsets.all(0),
                    title: Text('Não exibir esta mensagem novamente'),
                    onChanged: (valor) {
                      setState(() => naoReexibir = valor ?? false);
                      try {
                        Preferencias.instancia
                            .exibirMsgTermosCondicoesPolitica = !naoReexibir;
                      } catch (_) {}
                    },
                  );
                }))
              ],
            );
          }),
          actions: [
            AppTextButton(
              primary: true,
              child: const Text('LER POLÍTICA DE PRIVACIDADE'),
              onPressed: () => mostrarPolitica(),
            ),
            AppTextButton(
              primary: true,
              child: const Text('LER TERMOS E CONDIÇÕES'),
              onPressed: () => mostrarTemos(),
            ),
            Builder(builder: (context) {
              return AppTextButton(
                primary: false,
                child: const Text('FECHAR'),
                onPressed: () => Navigator.pop(context),
              );
            }),
          ],
        );
}
