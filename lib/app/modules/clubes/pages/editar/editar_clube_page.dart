import 'package:flutter/material.dart';

import '../../shared/models/clube.dart';

class EditarClubePage extends StatefulWidget {
  final Clube clube;
  const EditarClubePage(this.clube, {Key? key}) : super(key: key);

  @override
  _EditarClubePageState createState() => _EditarClubePageState();
}

class _EditarClubePageState extends State<EditarClubePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Editar'),
    );
  }
}
