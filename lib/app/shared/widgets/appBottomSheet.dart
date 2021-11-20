import 'dart:ui';

import 'package:flutter/material.dart';

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
    this.scrollable = false,
    this.transitionAnimationController,
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
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final Clip? clipBehavior;
  final ShapeBorder shape;
  final bool scrollable;
  final AnimationController? transitionAnimationController;

  /// Exibir bottom sheet modal.
  Future<T?> showModal<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      shape: shape,
      elevation: elevation,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      transitionAnimationController: transitionAnimationController,
      builder: (context) => build(context),
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
      builder: (context) => build(context),
    );
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
              theme.textTheme.headline6 ??
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
              theme.textTheme.subtitle1!,
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
        if (i < actions!.length - 1) _children.add(divider());
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

    final anchor = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          width: 48.0,
          child: const Divider(
            height: 10.0,
            thickness: 3.0,
          ),
        ),
      ],
    );

    List<Widget> columnChildren;
    if (scrollable) {
      columnChildren = <Widget>[
        if (title != null || content != null) anchor,
        if (title != null || content != null)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title != null) titleWidget!,
                  if (content != null) contentWidget!,
                ],
              ),
            ),
          ),
        if (actions != null) divider(),
        if (actions != null) actionsWidget!,
      ];
    } else {
      columnChildren = <Widget>[
        if (title != null || content != null) anchor,
        if (title != null) titleWidget!,
        if (content != null) Flexible(child: contentWidget!),
        if (actions != null) divider(),
        if (actions != null) actionsWidget!,
      ];
    }

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

/// Uma página inferior que exibe dois botões de ação.
/// Ao ser fechada, retorna:
/// * [resultActionFirst] se o primeiro botão for acionado;
/// * [resultActionLast] se o último botão for acionado; ou
/// * `null` nos demais casos.
class BottomSheetAcoes extends AppBottomSheet {
  const BottomSheetAcoes({
    Key? key,
    this.title,
    this.content,
    this.labelActionFirst = 'CONFIRMAR',
    this.labelActionLast = 'CANCELAR',
    this.actionFirstIsPrimary = true,
    this.actionLastIsPrimary = false,
    this.resultActionFirst = true,
    this.resultActionLast = false,
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
  final resultActionFirst;

  /// Retorno da página quando o último botão é acionado.
  final resultActionLast;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      content: content,
      actions: [
        AppTextButton(
          primary: actionFirstIsPrimary,
          child: Text(labelActionFirst),
          onPressed: () => Navigator.pop<bool>(context, resultActionFirst),
        ),
        AppTextButton(
          primary: actionLastIsPrimary,
          child: Text(labelActionLast),
          onPressed: () => Navigator.pop<bool>(context, resultActionLast),
        ),
      ],
    );
  }
}

/// Uma página inferior para confirmar ou cancelar uma ação.
/// Ao ser fechada, retorna `true` se o usuário confirmar a ação.
class BottomSheetCancelarConfirmar extends BottomSheetAcoes {
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
class BottomSheetCancelarSair extends BottomSheetAcoes {
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
