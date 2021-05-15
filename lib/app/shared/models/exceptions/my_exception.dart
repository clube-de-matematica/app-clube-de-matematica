///Contém as propriedades de exceções comuns a todo o aplicativo.
class MyException implements Exception {
  MyException(
    this.message, {
    this.error,
    this.originClass,
    this.originField,
    this.fieldDetails,
    this.causeError,
  }) : assert(!((originClass == null) && (originField != null)));

  ///Mensagem de erro.
  final String? message;

  ///Objeto de erro lançado originalmente.
  final Object? error;

  ///Classe onde o erro foi lançado.
  final String? originClass;

  ///Campo ou método onde o erro foi lançado.
  ///Deve seguir o padão: "meuCampo ou meuMetodo(...)".
  final String? originField;

  ///Detalhamento em [originField].
  final String? fieldDetails;

  ///Informações da causa do erro.
  final String? causeError;

  @override
  String toString() {
    String? origin;
    if (originField != null) origin = "--> $originField";
    if (originClass != null) origin = "$originClass ${origin ?? ""}";
    return "\n"
        " mensagem: ${message.toString()}\n"
        " origem: ${origin.toString()}\n"
        " detalhes na origem: ${fieldDetails.toString()}\n"
        " causa: ${causeError.toString()}\n"
        " error: ${error.toString()}\n";
  }
}

///Lançada quando um recurso indisponível para a web é solicitado pela versão web do aplicativo.
///[causeError] deve seguir o padão: "MinhaClasse(meuCampo ou meuMetodo(...): Causa do erro: ...)".
class MyExceptionNoWebSupport extends MyException {
  MyExceptionNoWebSupport({
    String? originClass,
    String? originField,
    String? fieldDetails,
    String? causeError,
  }) : super(
          "Não disponível para a versão web.",
          originClass: originClass,
          originField: originField,
          fieldDetails: fieldDetails,
          causeError: causeError,
        );
}
