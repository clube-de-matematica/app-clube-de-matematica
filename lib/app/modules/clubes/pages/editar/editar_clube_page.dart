import 'package:clubedematematica/app/shared/widgets/appBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../modules/clubes/pages/editar/editar_clube_controller.dart';
import '../../../../shared/widgets/bottomAppBar_cancelar_aplicar.dart';
import '../../shared/models/clube.dart';
import '../../shared/utils/tema_clube.dart';
import '../../shared/widgets/bottom_sheet_erro.dart';
import '../../shared/widgets/color_picker.dart';
import '../../shared/widgets/gerar_codigo_list_tile_form_field.dart';
import '../../shared/widgets/text_form_fields.dart';

class EditarClubePage extends StatefulWidget {
  final Clube clube;
  const EditarClubePage(this.clube, {super.key});

  @override
  EditarClubePageState createState() => EditarClubePageState();
}

class EditarClubePageState extends State<EditarClubePage> {
  final controller = EditarClubeController();
  bool isLoading = false;
  late String nome;
  String? descricao;
  late Color corTema;
  late bool privado;
  late String codigo;

  @override
  Widget build(BuildContext context) {
    nome = widget.clube.nome;
    descricao = widget.clube.descricao;
    corTema = widget.clube.capa;
    privado = widget.clube.privado;
    codigo = widget.clube.codigo;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(builder: (context) {
        return Theme(
          data: Modular.get<TemaClube>().tema,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Editar'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: NomeClubeTextFormField(
                    initialValue: nome,
                    onSaved: (valor) {
                      if (valor != null) nome = valor.trim();
                    },
                    validator: controller.validarNome,
                  ),
                ),
                DescricaoClubeTextFormField(
                  initialValue: descricao,
                  onSaved: (valor) => descricao = valor?.trim(),
                ),
                ColorPickerListTileFormField(
                  initialColor: corTema,
                  onSaved: (cor) {
                    if (cor != null) corTema = cor;
                  },
                ),
                // TODO: Será implementado posteriormente como um novo recurso.
                /* SwitchListTileFormField(
                    valorInicial: !privado,
                    onSaved: (aberto) {
                      if (aberto != null) privado = !aberto;
                    },
                  ), */
                GerarCodigoListTileFormField(
                  codigo: codigo,
                  onSaved: (codigo) {
                    if (codigo != null) this.codigo = codigo;
                  },
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBarCancelarAplicar(
              onAplicar: () async {
                if (!isLoading) {
                  final form = Form.of(context);
                  if (form.validate()) {
                    isLoading = true;
                    form.save();
                    final futuro = controller.atualizar(
                      context,
                      clube: widget.clube,
                      nome: nome,
                      codigo: codigo,
                      descricao: descricao,
                      corTema: corTema,
                      privado: privado,
                    );
                    await BottomSheetCarregando(future: futuro)
                        .showModal(context);
                    final sucesso = await futuro;
                    if (sucesso) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      if (context.mounted) {
                        await const BottomSheetErroAtualizarClube()
                            .showModal(context);
                      }
                    }
                    isLoading = false;
                  }
                }
              },
              onCancelar: () {
                if (!isLoading) Navigator.of(context).pop(false);
              },
            ),
          ),
        );
      }),
    );
  }
}
