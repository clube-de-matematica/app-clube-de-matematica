import 'package:flutter/material.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../shared/widgets/color_picker.dart';

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
    corTema = widget.initialColor;
    return Form(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Crie um clube:',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          _buildTextFormField(
            maxLength: 50,
            labelText: 'Nome',
            hintText: 'Digite o nome do clube',
            onSaved: (valor) => nome = valor,
            validator: widget.validarNome,
          ),
          _buildTextFormField(
            maxLength: 200,
            maxLines: 5,
            labelText: 'Descrição',
            hintText: 'Digite uma rápida descrição do clube',
            onSaved: (valor) => descricao = valor,
          ),
          _buildTema(),
          _buildSwitchListTile(),
          TextButton(
            child: const Text('CRIAR'),
            onPressed: isLoading
                ? null
                : ()async {
                    if (Form.of(context)?.validate() ?? false) {
                      setState(() => isLoading = true);
                      await widget.onCriar
                          ?.call(nome!, descricao, corTema!, !grupoAberto);
                      setState(() => isLoading = false);
                    }
                  },
          ),
        ],
      ),
    );
  }

  FormField<Color> _buildTema() {
    return FormField<Color>(
      builder: (field) {
        return UnmanagedRestorationScope(
          bucket: field.bucket,
          child: ColorPickerListTile(
            initialColor: corTema,
            colorChange: (novaCor) => field.didChange(novaCor),
          ),
        );
      },
      onSaved: (cor) => corTema = cor,
      validator: (cor) {
        if (cor == null) corTema = widget.initialColor;
      },
    );
  }

  FormField<bool> _buildSwitchListTile() {
    return FormField<bool>(
      builder: (field) {
        return UnmanagedRestorationScope(
          bucket: field.bucket,
          child: SwitchListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: const Text('Grupo aberto'),
            subtitle: const Text(
                'Qualquer pessoa com o código de acesso pode participar?'),
            value: grupoAberto,
            onChanged: (value) {
              setState(() {
                grupoAberto = value;
              });
              field.didChange(value);
            },
          ),
        );
      },
      onSaved: (gpAberto) {
        if (gpAberto != null) grupoAberto = gpAberto;
      },
    );
  }

  TextFormField _buildTextFormField({
    TextAlign textAlign = TextAlign.start,
    String? labelText,
    String? hintText,
    String? initialValue,
    int? maxLength,
    int? maxLines,
    TextStyle? style,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    // Estilo do texto dos rótulos do formulário.
    final labelStyle = TextStyle(fontSize: 16 * AppTheme.escala);
    return TextFormField(
      autofocus: true,
      textAlign: textAlign,
      keyboardType: TextInputType.text,
      maxLength: maxLength,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        border: const OutlineInputBorder(),
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //prefixIcon: Icon(Icons.person),
      ),
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
