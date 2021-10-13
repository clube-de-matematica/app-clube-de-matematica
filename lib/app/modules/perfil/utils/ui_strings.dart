/// Strings para a página de perfil.
abstract class UIStrings {
  /// Rótulo para a caixa de texto do nome do usuário.
  static const kNameLabelText = "Nome";

  /// Mensagem na caixa de texto quando ela estiver vazia.
  static const kNameHintText = "Como deseja ser chamado?";

  /// Mensagem para indicar o preenchimento obrigatório.
  static const kNameValidationMsgCampoObrigatotio = "Campo obrigatório";

  /// Mensagem informando o número mínimo de caracteres para o nome do usuário.
  static const kNameValidationMsgMinCaracter =
      "O nome deve conter no mínimo três caracteres";

  /// Título do botão para alterar a conta Google do usuário.
  static const kChangeAccountButtonTitle = 'Usar outra conta';

  /// Mensagem de confirmação para alterar a conta Google do usuário.
  static const kAccountChangeConfirmationMsg =
      'Deseja realmente alterar a conta conectada?';

  /// Título do botão para desconectar o usuário.
  static const kExitButtonTitle = 'Sair';

  /// Mensagem de confirmação para desconectar o usuário.
  static const kExitConfirmationMsg = 'Deseja realmente sair da conta atual?';

  /// Título do botão para confirmar uma ação iniciada.
  static const kConfirmButtonTitle = "CONTINUAR";

  /// Título do botão para cancelar uma ação iniciada.
  static const kCancelButtonTitle = "CANCELAR";
}
