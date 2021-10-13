import 'interface_db_repository.dart';

/// mixin para os subtipos de [IDbRepository] que usam SQL.
mixin DbSqlMixin {
  /// Nome da visualização que consolida os dados das questões.
  /// Esta visualização conterá um registro para cada aplicação da questão. Isso significa que
  /// se a questão foi aplicado em dois cadernos, possuirá um registro para cada um destes.
  /// Criada para facilitar as consultas de dados.
  final viewQuestoes = "view_questoes";
}
