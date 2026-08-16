import 'package:flutter/material.dart';

///Utilize este [Widget] quando precisar que [child] contenha um [Flexible] widget.
class ScrollViewWithChildExpandable extends StatelessWidget {
  final Widget child;

  const ScrollViewWithChildExpandable({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: child,
          ),
        ],
      ),
    );
  }
}
