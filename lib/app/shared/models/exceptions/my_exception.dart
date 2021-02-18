///Contém as propriedades de exceções comuns a todo o aplicativo.
class MyException implements Exception {
  MyException(this.message, [this.error, this.detalhes]);

  ///Mensagem de erro.
  final String message;

  ///Objeto de erro lançado originalmente.
  final Exception error;

  ///Detalhamento do lançamento desta exceção.
  final String detalhes;

  @override
  String toString() => "MyException("
        "mensagem: ${message ?? ""}\n"
        "detalhes: ${detalhes ?? ""}\n"
        "error: ${error.toString()})";

  @override
  int get hashCode => message.hashCode;
}
