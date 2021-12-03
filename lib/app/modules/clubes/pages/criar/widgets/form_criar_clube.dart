import 'package:flutter/material.dart';

import '../../../shared/utils/random_colors.dart';
import '../../../shared/widgets/color_picker.dart';
import '../../../shared/widgets/text_form_fields.dart';

/// Formulário para a criação de um clube.
class FormCriarClube extends StatefulWidget {
  const FormCriarClube({
    Key? key,
    this.initialColor,
    this.validarNome,
    this.onCriar,
  }) : super(key: key);

  /// Valor inicial para a cor do tema.
  final Color? initialColor;

  /// Ação executada na validação do nome do clube.
  final String? Function(String?)? validarNome;

  /// Ação executada ao precionar o botão de confirmação.
  final Future Function(
      String nome, String? descricao, Color corTema, bool privado)? onCriar;

  @override
  State<FormCriarClube> createState() => _FormCriarClubeState();
}

class _FormCriarClubeState extends State<FormCriarClube> {
  bool isLoading = false;
  String? nome;
  String? descricao;
  Color? corTema;
  bool grupoAberto = true;

  @override
  Widget build(BuildContext context) {
    corTema = widget.initialColor ?? RandomColor();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 8.0),
            NomeClubeTextFormField(
              onSaved: (valor) => nome = valor?.trim(),
              validator: widget.validarNome,
            ),
            const SizedBox(height: 8.0),
            DescricaoClubeTextFormField(
              onSaved: (valor) => descricao = valor?.trim(),
            ),
            ColorPickerListTileFormField(
              onSaved: (cor) {
                if (cor != null) corTema = cor;
              },
            ),
            // TODO: Será implementado posteriormente como um novo recurso.
            /* SwitchListTileFormField(
              onSaved: (gpAberto) {
                if (gpAberto != null) grupoAberto = gpAberto;
              },
            ), */
            TextButton(
              child: const Text('CRIAR'),
              onPressed: isLoading
                  ? null
                  : () async {
                      final form = Form.of(context);
                      if (form?.validate() ?? false) {
                        setState(() => isLoading = true);
                        form?.save();
                        await widget.onCriar
                            ?.call(nome!, descricao, corTema!, !grupoAberto);
                        if (mounted) setState(() => isLoading = false);
                      }
                    },
            ),
          ],
        );
      }),
    );
  }
}
