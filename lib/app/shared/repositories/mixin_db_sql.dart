import 'interface_db_repository.dart';

/// mixin para os subtipos de [IDbRepository] que usam SQL.
mixin DbSqlMixin {
  /// Nome da visualização que consolida os dados das questões.
  /// Esta visualização conterá um registro para cada aplicação da questão. Isso significa que
  /// se a questão foi aplicado em dois cadernos, possuirá um registro para cada um destes.
  /// Criada para facilitar as consultas de dados.
  final viewQuestoes = 'view_questoes';

  /// Nome da tabela que faz o relacionamento muitos para muitos entre as tabelas "clubes" e 
  /// "usuarios".
  final tbClubeXUsuario = 'clube_x_usuario';

  /// Nome da coluna para o ID do clube na tabela [tbClubeXUsuario].
  final tbClubeXUsuarioColIdClube = 'id_clube';

  /// Nome da coluna para o ID do usuário na tabela [tbClubeXUsuario].
  final tbClubeXUsuarioColIdUsuario = 'id_usuario';

  /// Nome da coluna para o ID de acesso do usuário ao clube na tabela [tbClubeXUsuario].
  final tbClubeXUsuarioColIdPermissao = 'id_permissao';
}
