import 'package:clubedematematica/app/shared/widgets/myDrawer.dart';
import 'package:flutter/material.dart';

/// Página inicial para visualização dos clubes do usuário.
class HomeClubesPage extends StatefulWidget {
  const HomeClubesPage({Key? key}) : super(key: key);

  @override
  _HomeClubesPageState createState() => _HomeClubesPageState();
}

class _HomeClubesPageState extends State<HomeClubesPage> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      body: Container(),
    );
  }
}
