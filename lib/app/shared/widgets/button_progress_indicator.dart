import 'dart:async';

import 'package:flutter/material.dart';

/// Quando este botão for acionado, [child] será substituído por um [CircularProgressIndicator]
/// até que [onPressed] seja concluido.
class ButtonProgressIndicator extends StatefulWidget {
  /// Se `true`, quando acionado, este botão será transformado em um cículo.
  /// O padrão é `false`.
  final bool transform;

  /// Quando este botão for acionado, permanecerá em progresso até que [onPressed] seja
  /// concluido.
  final Future Function()? onPressed;
  final Widget? child;
  final Color? primary;
  final Color? onPrimary;
  final Color? onSurface;
  final Color progressIndicatorColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final bool isLoading;

  const ButtonProgressIndicator({
    super.key,
    required this.onPressed,
    this.child,
    this.primary,
    this.onPrimary,
    this.onSurface,
    this.progressIndicatorColor = Colors.white,
    this.margin,
    this.padding,
    this.elevation,
    this.transform = false,
    this.isLoading = false,
  });

  @override
  ButtonProgressIndicatorState createState() =>
      ButtonProgressIndicatorState();
}

class ButtonProgressIndicatorState extends State<ButtonProgressIndicator>
    with TickerProviderStateMixin {
  /// Será `true` quando [widget.onParticipar] estiver em andamento e `false` nos
  /// demais casos.
  late bool _isLoading;
  late double _initialWidth;
  double _width = double.maxFinite;
  final _height = 48.0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  final Animatable<double> _easeOutTween = CurveTween(curve: Curves.linear);

  final ColorTween _backgroundColorTween = ColorTween();

  late final Animation<Color?> _backgroundColor =
      _controller.drive(_backgroundColorTween.chain(_easeOutTween));
  late final Animation _animation;

  ThemeData get tema => Theme.of(context);

  Color get textColor1 => tema.colorScheme.onSurface.withOpacity(0.6);

  @override
  void initState() {
    super.initState();

    _isLoading = widget.isLoading;

    if (widget.transform) {
      _animation = Tween(begin: 0.0, end: 1).animate(_controller)
        ..addListener(() {
          if (mounted) {
            setState(() {
              _width = _initialWidth -
                  ((_initialWidth - _height) * _animation.value);
            });
          }
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    _backgroundColorTween
      ..begin = widget.primary
      ..end = Colors.grey[350];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: widget.margin,
        child: AnimatedBuilder(
          animation: _controller.view,
          child: setUpButtonChild(),
          builder: (context, child) {
            var styleFrom = ElevatedButton.styleFrom(
              backgroundColor: _backgroundColor.value,
              foregroundColor: widget.onPrimary,
              disabledBackgroundColor: widget.onSurface,
              disabledForegroundColor: widget.onSurface,
              padding: widget.padding,
              elevation: widget.elevation,
              fixedSize: Size(_width, _height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_height / 2),
              ),
              animationDuration: const Duration(milliseconds: 1000),
            );
            return ElevatedButton(
              style: styleFrom,
              child: child,
              onPressed: () {
                _initialWidth = context.size?.width ?? _height;
                if (!_isLoading) {
                  animateButton();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget? setUpButtonChild() {
    if (!_isLoading) {
      return widget.child;
    } else {
      return SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(
          //value: null,
          valueColor:
              AlwaysStoppedAnimation<Color>(widget.progressIndicatorColor),
          strokeWidth: 2.0,
        ),
      );
    }
  }

  void animateButton() {
    final onPressed = widget.onPressed;
    if (onPressed != null) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (widget.transform) _controller.forward();

      onPressed().whenComplete(() async {
        if (widget.transform) {
          if (_controller.isAnimating) _controller.stop();
          await _controller.reverse();
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
