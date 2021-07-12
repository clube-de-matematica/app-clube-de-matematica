import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

///Widget com efeito de brilho para ser usado como espaço reservado.
class MyShimmer extends Shimmer {
  MyShimmer({
    Widget? child,
    double? width,
    double? height,
    Color baseColor = const Color(0xFFEEEEEE), //Color(0xFFEBEBF4),
    Color highlightColor = const Color(0xFFFCFCFC), //Color(0xFFF4F4F4),
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.ltr,
    int loop = 0,
    bool enabled = true,
  }) : super.fromColors(
          child: Container(
            width: width,
            height: height,
            color: Colors.white, //Necessário para o Shimmer.
            child: child,
          ),
          baseColor: baseColor,
          highlightColor: highlightColor, //Color(0xFFF4F4F4),
          period: period,
          direction: direction,
          loop: loop,
          enabled: enabled
        );
}
