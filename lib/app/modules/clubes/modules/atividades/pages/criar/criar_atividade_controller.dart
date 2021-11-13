class CriarAtividadeController {
  /// Retorna `null` se [titulo] for um título válido, caso contrário, retorna uma
  /// mensagem de erro.
  String? validarTitulo(String? titulo) {
    if (titulo?.isEmpty ?? true) return 'Insira um título';
    return null;
  }
}
