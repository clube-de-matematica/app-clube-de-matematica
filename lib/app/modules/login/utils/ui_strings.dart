// ignore_for_file: constant_identifier_names

import '../../../shared/utils/constantes.dart';

/// Strings para a página de loguin.
abstract class UIStrings {
  /// Mensagem de boas vindas.
  static const LOGIN_MSG_BEM_VINDO = "Bem vindo ao App $APP_NOME.";

  /// Mensagem orientando para conectar-se com a conta Google.
  static const LOGIN_MSG_SOB_BEM_VINDO =
      "Entre com a sua conta Google para ter acesso a todos os recursos.";

  /// Título do botão para conectar-se anonimamente.
  static const LOGIN_TEXT_BUTTON_USER_ANONYMOUS = "Fazer isso mais tarde";

  /// Título do botão para conectar-se com a conta do Google.
  static const LOGIN_TEXT_BUTTON_USER_GOOGLE = "Entrar com o Google";

  /// Mensagem de confirmação para conectar-se anonimamente.
  static const LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_MSG =
      "Você terá acesso ao banco de questões, mas "
      "não poderá criar ou participar de Clubes de Matemática.";

  /// Título do botão para confirmação no popup de confirmação para conectar-se anonimamente.
  static const LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CONFIRM = "CONTINUAR";

  /// Título do botão para cancelamento no popup de confirmação para conectar-se anonimamente.
  static const LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CANCEL = "CANCELAR";

  /// Título do popup de notificação de erro.
  static const LOGIN_DIALOG_ERROR_TITLE = "Erro de altenticação";

  /// Mensagem do popup de notificação de erro.
  static const LOGIN_DIALOG_ERROR_MSG =
      "Ocorreu um erro ao fazer a autenticação do usuário. Tente novamente.";

  /// Título do botão para fechar popup de notificação de erro.
  static const LOGIN_DIALOG_ERROR_TEXT_BUTTON_CLOSE = "FECHAR";
}
