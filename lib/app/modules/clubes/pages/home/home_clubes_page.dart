import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import 'home_clubes_controller.dart';

/// Página inicial para visualização dos clubes do usuário.
class HomeClubesPage extends StatefulWidget {
  const HomeClubesPage({Key? key}) : super(key: key);

  @override
  _HomeClubesPageState createState() => _HomeClubesPageState();
}

class _HomeClubesPageState
    extends ModularState<HomeClubesPage, HomeClubesController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      page: AppDrawerPage.clubes,
      appBar: AppBar(title: const Text('Clubes')),
      body: Observer(builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (var clube in _buildCards(context)) clube,
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: controller.addClube,
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    final userId = controller.user.id;
    return controller.clubes.map((clube) {
      String subtitle;

      if (userId == clube.proprietario)
        subtitle = 'Proprietário';
      else if (clube.administradores.contains(userId))
        subtitle = 'Administrador';
      else
        subtitle = 'Membro';

      return GestureDetector(
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text(clube.nome),
                subtitle: Text(subtitle),
                //leading: CircleAvatar(),
              ),
            ],
          ),
        ),
        onTap: () => controller.openClubePage(context, clube),
      );
    }).toList();
  }
}
