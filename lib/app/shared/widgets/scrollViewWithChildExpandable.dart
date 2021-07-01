import 'package:flutter/material.dart';

///Utilize este [Widget] quando precisar que [child] contenha um [Flexible] widget.
class ScrollViewWithChildExpandable extends StatelessWidget {
  final Widget child;

  const ScrollViewWithChildExpandable({Key? key, required this.child})
      : super(key: key);

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
