import 'package:clubedematematica/app/modules/clubes/shared/widgets/switch_list_tile_form_field.dart';
import 'package:clubedematematica/app/shared/repositories/id_base62.dart';
import 'package:flutter/material.dart';

import '../../../../modules/clubes/pages/editar/editar_clube_controller.dart';
import '../../../../shared/widgets/bottomAppBar_cancelar_aplicar.dart';
import '../../shared/models/clube.dart';
import '../../shared/widgets/bottom_sheet_erro.dart';
import '../../shared/widgets/color_picker.dart';
import '../../shared/widgets/text_form_fields.dart';

class EditarClubePage extends StatefulWidget {
  final Clube clube;
  const EditarClubePage(this.clube, {Key? key}) : super(key: key);

  @override
  _EditarClubePageState createState() => _EditarClubePageState();
}

class _EditarClubePageState extends State<EditarClubePage> {
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
            final sucesso = await controller.atualizar(
                context, nome, descricao, corTema, privado);
            if (!sucesso) {
              await BottomSheetErroAtualizarClube().showModal(context);
            }
          },
          onCancelar: () {
            if (!isLoading) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

/// Um [ListTile] que extende [FormField].
/// Usado para gerar um novo código de acesso para o clube.
class GerarCodigoListTileFormField extends FormField<String> {
  GerarCodigoListTileFormField({
    Key? key,
    required String codigo,
    void Function(String?)? onSaved,
  }) : super(
          key: key,
          initialValue: codigo,
          builder: (field) {
            final state = field as _GerarCodigoListTileFormFieldState;
            return UnmanagedRestorationScope(
              bucket: state.bucket,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: const Text('Código'),
                subtitle: state.subtitulo,
                trailing: state.trailing,
                onTap: () => state.didChange(IdBase62.getIdClube()),
              ),
            );
          },
          onSaved: onSaved,
        );

  @override
  FormFieldState<String> createState() => _GerarCodigoListTileFormFieldState();
}

class _GerarCodigoListTileFormFieldState extends FormFieldState<String> {
  /// Verdadeido se um novo código foi gerado.
  bool get salvo => value == widget.initialValue;

  Widget get subtitulo =>
      Text(salvo ? 'Toque para gerar um novo código' : value ?? '');

  Widget get trailing {
    return salvo
        ? SelectableText(
            widget.initialValue ?? '',
            style: TextStyle(fontSize: 20.0),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 36.0,
              ),
              onPressed: () => reset(),
            ),
          );
  }

  @override
  void save() {
    if (!salvo) super.save();
  }

  @override
  void didChange(String? value) {
    if (value != null && value != this.value) {
      super.didChange(value);
    }
  }

  @override
  GerarCodigoListTileFormField get widget =>
      super.widget as GerarCodigoListTileFormField;
}
