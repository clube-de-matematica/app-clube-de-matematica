import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

///Widget com efeito de brilho para ser usado como espaço reservado.
class AppShimmer extends Shimmer {
  AppShimmer({super.key, 
    Widget? child,
    double? width,
    double? height,
    super.baseColor = const Color(0xFFEEEEEE), //Color(0xFFEBEBF4),
    super.highlightColor = const Color(0xFFFCFCFC), //Color(0xFFF4F4F4),
    super.period,
    super.direction,
    super.loop,
    super.enabled,
  }) : super.fromColors(
          child: Container(
            width: width,
            height: height,
            color: Colors.white, //Necessário para o Shimmer.
            child: child,
          )
        );
}
