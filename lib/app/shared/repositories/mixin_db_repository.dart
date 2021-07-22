import 'interface_db_repository.dart';

/// mixin para os subtipos de [IDbRepository].
mixin DbRepositoryMixin {
  /// Retorna `true` se [id] estiver de acordo com o padrão `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se do primeiro item do caderno.
  bool validateId(String id) {
    final exp = RegExp(
      // Correspondência para o exemplo 2019PF1N1Q01:
      "^" // Início da linha
      "(20)" // "20"
      "([0-9]{1,2})" // "19"
      "(p|P)(f|F)(1|2|3)" // "PF1"
      "(n|N)(1|2|3)" // "N1"
      "(q|Q)([0-5]{1})([1-9]{1})" // "Q01"
      "\$", // Final da linha
    );
    return exp.hasMatch(id);
  }
}
