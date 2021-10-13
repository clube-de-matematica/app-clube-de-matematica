import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/widgets/scaffoldWithDrawer.dart';
import '../shared/models/clube.dart';

class ClubePage extends StatefulWidget {
  final Clube clube;

  const ClubePage(this.clube, {Key? key}) : super(key: key);

  @override
  _ClubePageState createState() => _ClubePageState();
}

class _ClubePageState extends State<ClubePage> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return ScaffoldWithDrawer(
        page: AppDrawerPage.clubes,
        appBar: AppBar(title: Text(widget.clube.nome)),
        body: Container(),
      );
    });
  }
}
