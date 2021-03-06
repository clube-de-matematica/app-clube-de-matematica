import 'package:image_picker/image_picker.dart';

import '../models/userapp.dart';
import '../utils/strings_interface.dart';

class PerfilController {
  final UserApp user;
  PerfilController(this.user);

  ///Retorna uma `String` com uma mensagem correspondente a um erro de validação para o nome digitado pelo usuário.
  ///Retorna `null` se o nome for válido.
  String nameValidator(valor) {
    if (valor.isEmpty) return VALIDACAO_NOME_MSG_CAMPO_OBRIGATORIO;
    if (valor.trim().length < 3) return VALIDACAO_NOME_MSG_MIN_CARACTER;
    return null;
  }

  ///Nome do usuário.
  get nome => user.name;

  ///Nome do usuário.
  set name(String valor) => user.name = valor;

  void setAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) user.pathAvatar = pickedFile.path;
  }
}
