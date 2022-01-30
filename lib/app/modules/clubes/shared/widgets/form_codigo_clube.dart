import 'package:flutter/material.dart';

/// Formulario para participar de um clube com o código.
class FormCodigoClube extends StatefulWidget {
  const FormCodigoClube({Key? key, this.onParticipar}) : super(key: key);

  /// Ação executada ao precionar o botão de confirmação.
  final Future Function(String)? onParticipar;

  @override
  State<FormCodigoClube> createState() => _FormCodigoClubeState();
}

class _FormCodigoClubeState extends State<FormCodigoClube> {
  final controller = TextEditingController();
  final maxLength = 6;
  bool activateButton = false;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Entre com um código de acesso:',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLength: maxLength,
          style: TextStyle(fontSize: 26.0),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.all(0),
          ),
          onChanged: (value) {
            setState(() {
              activateButton = value.length == maxLength;
            });
          },
        ),
        TextButton(
          child: const Text('PARTICIPAR'),
          onPressed: activateButton && !isLoading
              ? () async {
                  setState(() => isLoading = true);
                  await widget.onParticipar?.call(controller.value.text);
                  setState(() => isLoading = false);
                }
              : null,
        ),
      ],
    );
  }
}
