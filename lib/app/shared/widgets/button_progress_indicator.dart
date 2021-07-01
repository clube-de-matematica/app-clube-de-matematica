import 'dart:async';

import 'package:flutter/material.dart';

class ButtonProgressIndicator extends StatefulWidget {
  ///Se `true`, quando acionado, este botão será transformado em um cículo.
  ///O padrão é `false`.
  final bool transform;

  ///Quando este botão for acionado, permanecerá em progresso até que [onPressed] seja
  ///concluido.
  final Future Function()? onPressed;
  final Widget? child;
  final Color? primary;
  final Color? onPrimary;
  final Color? onSurface;
  final Color progressIndicatorColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const ButtonProgressIndicator({
    Key? key,
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
  }) : super(key: key);

  @override
  _ButtonProgressIndicatorState createState() =>
      _ButtonProgressIndicatorState();
}

class _ButtonProgressIndicatorState extends State<ButtonProgressIndicator>
    with TickerProviderStateMixin {
  int _state = 0;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;
  final _height = 48.0;

  late Animation _animation;
  late AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this);

  ThemeData get tema => Theme.of(context);

  Color get textColor1 => tema.colorScheme.onSurface.withOpacity(0.6);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: widget.margin,
        child: ElevatedButton(
          key: _globalKey,
          style: ElevatedButton.styleFrom(
            primary: widget.primary,
            onPrimary: widget.onPrimary,
            onSurface: widget.onSurface,
            padding: widget.padding,
            elevation: widget.elevation,
            fixedSize: Size(_width, _height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_height / 2),
            ),
            animationDuration: Duration(milliseconds: 1000),
          ),
          child: setUpButtonChild(),
          onPressed: () {
            if (_state == 0) {
              animateButton();
            }
          },
        ),
      ),
    );
  }

  Widget? setUpButtonChild() {
    if (_state == 0) {
      return widget.child;
    } else if (_state == 1) {
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
    } else {
      return null;
    }
  }

  void animateButton() {
    final _onPressed = widget.onPressed;
    if (_onPressed != null) {
      if (widget.transform) {
        double initialWidth = _globalKey.currentContext?.size?.width ?? 0.0;

        _animation = Tween(begin: 0.0, end: 1).animate(_controller)
          ..addListener(() {
            setState(() {
              _width =
                  initialWidth - ((initialWidth - _height) * _animation.value);
            });
          });
        _controller.forward();
      }

      setState(() {
        _state = 1;
      });

      _onPressed().whenComplete(() async {
        if (widget.transform) await _controller.reverse();
        setState(() {
          _state = 0;
        });
      });
    }
  }
}
