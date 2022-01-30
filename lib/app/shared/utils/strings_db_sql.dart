import 'strings_db.dart';

abstract class Sql {
  static get dataModificacao => DbConst.kDbDataDocumentKeyDataModificacao;
  static const tbQuestoes = _TbQuestoes();
  static const tbAssuntos = _TbAssuntos();
  static const tbQuestaoAssunto = _TbQuestaoAssunto();
  static const tbTiposAlternativa = _TbTiposAlternativa();
  static const tbAlternativas = _TbAlternativas();
  static const tbQuestoesCaderno = _TbQuestoesCaderno();
  static const tbUsuarios = _TbUsuarios();
  static const tbClubes = _TbClubes();
  static const tbTiposPermissao = _TbTiposPermissao();
  static const tbClubeUsuario = _TbClubeUsuario();
  static const tbAtividades = _TbAtividades();
  static const tbQuestaoAtividade = _TbQuestaoAtividade();
  static const tbRespostaQuestaoAtividade = _TbRespostaQuestaoAtividade();
  static const tbRespostaQuestao = _TbRespostaQuestao();
}

abstract class _Tb {
  const _Tb();

  String get tbNome;

  /// Nome do campo para a data da última modificação (no fuso horário UTC) do registro.
  ///
  /// {@template app._Tb.dataModificacao}
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  /// {@endtemplate}
  String get dataModificacao => DbConst.kDbDataDocumentKeyDataModificacao;
}

mixin _ColunaExcluir on _Tb {
  String get excluir => DbConst.kDbDataDocumentKeyExcluir;
}

class _TbQuestoes extends _Tb {
  const _TbQuestoes();

  /// Nome da tabela para as questões.
  @override
  String get tbNome => 'questoes';

  /// Os valores para esse campo são do tipo [int].
  String get id => 'id';

  /// Nome do campo para o array com as partes do enunciado da questão.
  /// A fragmentação é para indicar pontos de inserção de imágens.
  /// Os pontos de inserção podem ser [stringImagemDestacada] ou [stringImagemNaoDestacada].
  ///
  /// Os valores para esse campo são do tipo [List]<[String]>.
  ///
  /// **Observação:** se o banco de dados não oferecer suporte a arreys, esse campo armazenará
  /// um arrey codificado em string json.
  String get enunciado => DbConst.kDbDataQuestaoKeyEnunciado;

  /// Nome do campo para o identificador ordinal da alternativa correta da questão.
  ///
  /// Os valores para esse campo devem corresponder a um [_TbAlternativas.sequencial]
  /// entre as alternativas da questão.
  String get gabarito => DbConst.kDbDataQuestaoKeyGabarito;

  /// Nome do campo para a lista com as imágens usadas no enunciado.
  ///
  /// Os valores para esse campo são do tipo [List]<[DataImagem]>.
  ///
  /// **Observação:** se o banco de dados não oferecer suporte a arreys, esse campo armazenará
  /// um arrey codificado em string json.
  String get imagensEnunciado => DbConst.kDbDataQuestaoKeyImagensEnunciado;

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem em uma nova linha.
  String get stringImagemDestacada => DbConst.kDbStringImagemDestacada;

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem na mesma linha.
  String get stringImagemNaoDestacada => DbConst.kDbStringImagemNaoDestacada;
}

class _TbAssuntos extends _Tb {
  const _TbAssuntos();

  /// Nome da tabela para os assuntos ligados a cada questão.
  @override
  String get tbNome => 'assuntos';

  /// Os valores para esse campo são do tipo [int].
  String get id => DbConst.kDbDataAssuntoKeyId;

  /// Os valores para esse campo são do tipo [String].
  String get titulo => DbConst.kDbDataAssuntoKeyTitulo;

  /// Nome do campo para a lista com a hierarquia de tópicos para o assunto, iniciando pela
  /// unidade. A lista não contém o assunto. Será uma lista vazia se o assunto for uma unidade.
  ///
  /// Os valores para esse campo são do tipo [DataHierarquia].
  String get hierarquia => DbConst.kDbDataAssuntoKeyHierarquia;
}

class _TbQuestaoAssunto extends _Tb {
  const _TbQuestaoAssunto();

  /// Nome da tabela para o relacionamento muitos para muitos entre as tabelas
  /// [Sql.tbQuestoes] e [Sql.tbAssuntos].
  @override
  String get tbNome => 'questao_x_assunto';

  /// Chave estranjeira de [_TbQuestoes.id].
  String get idQuestao => 'id_questao';

  /// Chave estranjeira de [_TbAssuntos.id].
  String get idAssunto => 'id_assunto';
}

class _TbTiposAlternativa extends _Tb {
  const _TbTiposAlternativa();

  /// Nome da tabela para os tipos de alternativa disponíveis
  @override
  String get tbNome => 'tipos_alternativa';

  /// Os valores para esse campo são do tipo [int].
  String get id => 'id';

  /// Os valores para esse campo são do tipo [String].
  String get tipo => 'tipo';
}

class _TbAlternativas extends _Tb {
  const _TbAlternativas();

  @override
  String get tbNome => 'alternativas';

  /// Chave estrangeira de [_TbQuestoes.id].
  String get idQuestao => DbConst.kDbDataAlternativaKeyIdQuestao;

  /// Nome do campo para o identificador ordinal da alternativa da questão.
  /// O primeiro valor é 0 (zero).
  ///
  /// Os valores para esse campo são do tipo [int].
  String get sequencial => DbConst.kDbDataAlternativaKeySequencial;

  /// Chave estrangeira de [_TbTiposAlternativa.id].
  String get idTipo => DbConst.kDbDataAlternativaKeyTipo;

  /// Tipo da alternativa da questão quando esta deva exibir um texto.
  int get tipoValTexto => DbConst.kDbDataAlternativaKeyTipoValTexto;

  /// Tipo da alternativa da questão quando esta deva exibir uma imagem.
  int get tipoValImagem => DbConst.kDbDataAlternativaKeyTipoValImagem;

  /// Nome do campo para o conteúdo da alternativa da questão.
  ///
  /// Os valores para esse campo são do tipo [String].
  /// * Se [idTipo] correspode a [tipoValTexto], contém o texto da alternativa
  /// (pode conter um código LaTex).
  /// * Se [idTipo] correspode a [tipoValImagem], contém a string base64 da imagem.
  String get conteudo => DbConst.kDbDataAlternativaKeyConteudo;
}

class _TbQuestoesCaderno extends _Tb {
  const _TbQuestoesCaderno();

  /// Nome da tabela que relaciona as questões por caderno.
  /// Se uma questão foi usada em mais de um caderno, nesta tabela ela possuirá um registro
  /// para cada um desses cadernos.
  @override
  String get tbNome => 'questoes_caderno';

  /// Nome do campo para o ID alfanumérico da questão.
  ///
  /// Os valores deste campo são do tipo [String] e estão no formato `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se da primeira questão do caderno.
  String get id => 'id';

  /// Nome do campo para o ano de aplicação da questão.
  ///
  /// Os valores para esse campo são do tipo [int].
  String get ano => DbConst.kDbDataQuestaoKeyAno;

  /// Nome do campo para o nível da prova da OBMEP.
  ///
  /// Os valores para esse campo são do tipo [int].
  String get nivel => DbConst.kDbDataQuestaoKeyNivel;

  /// Nome do campo para o número da questão no caderno de prova.
  ///
  /// Os valores para esse campo são do tipo [int].
  String get indice => DbConst.kDbDataQuestaoKeyIndice;

  /// Chave estrangeira de [_TbQuestoes.id].
  String get idQuestao => 'id_questao';
}

class _TbUsuarios extends _Tb {
  const _TbUsuarios();

  /// Nome da tabela para os usuários do aplicativo.
  @override
  String get tbNome => DbConst.kDbDataCollectionUsuarios;

  /// Nome do campo para o nome do usuário.
  ///
  /// Os valores desse campo são do tipo [String].
  String get nome => DbConst.kDbDataUserKeyNome;

  /// Nome do campo para o ID do usuário.
  ///
  /// Os valores desse campo são do tipo [int].
  String get id => DbConst.kDbDataUserKeyId;

  /// Nome do campo para o email do usuário.
  ///
  /// Os valores desse campo são do tipo [String].
  String get email => DbConst.kDbDataUserKeyEmail;

  /// Nome do campo para a string base64 (ou URL) da foto de perfil do usuário.
  ///
  /// Os valores desse campo são do tipo [String].
  String get foto => DbConst.kDbDataUserKeyFoto;

  /// Nome do campo para indicar se o usário foi excluído.
  ///
  /// Os valores desse campo são do tipo [bool].
  String get softDelete => 'soft_delete';
}

class _TbClubes extends _Tb with _ColunaExcluir {
  const _TbClubes();

  /// Nome da tabela para os clubes.
  @override
  String get tbNome => DbConst.kDbDataCollectionClubes;

  /// Nome do campo para o ID do clube.
  ///
  /// Os valores desse campo são do tipo [int].
  String get id => DbConst.kDbDataClubeKeyId;

  /// Nome do campo para o carimbo de data/hora da criação do clube.
  ///
  /// {@macro app._Tb.dataModificacao}
  String get dataCriacao => DbConst.kDbDataClubeKeyDataCriacao;

  /// Nome do campo para o nome do clube.
  ///
  /// Os valores desse campo são do tipo [String].
  String get nome => DbConst.kDbDataClubeKeyNome;

  /// Uma pequena descrição sobre o clube.
  ///
  /// Os valores desse campo são do tipo [String].
  String get descricao => DbConst.kDbDataClubeKeyDescricao;

  /// Nome do campo para o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  String get privado => DbConst.kDbDataClubeKeyPrivado;

  /// Nome do campo para a imágem ou a cor de capa.
  ///
  /// Os valores desse campo são do tipo [String].
  String get capa => DbConst.kDbDataClubeKeyCapa;

  /// Nome do campo para o ID base62 de acesso ao clube.
  ///
  /// Os valores desse campo são do tipo [String].
  String get codigo => DbConst.kDbDataClubeKeyCodigo;
}

class _TbTiposPermissao extends _Tb {
  const _TbTiposPermissao();

  /// Nome da tabela para os tipos de permissão disponíveis para os usuários.
  @override
  String get tbNome => 'tipos_permissao';

  /// Os valores para esse campo são do tipo [int].
  String get id => 'id';

  /// 0 (zero) para "proprietario", 1 para "administrador" e 2 para "membro".
  ///
  /// Os valores para esse campo são do tipo [String].
  String get permissao => 'permissao';
  int get idProprietario => 0;
  int get idAdministrador => 1;
  int get idMembro => 2;
}

class _TbClubeUsuario extends _Tb with _ColunaExcluir {
  const _TbClubeUsuario();

  /// Nome da tabela para o relacionamento muitos para muitos entre as tabelas
  /// [Sql.tbClubes] e [Sql.tbUsuarios].
  @override
  String get tbNome => 'clube_x_usuario';

  /// Chave estranjeira de [_TbClubes.id].
  String get idClube => 'id_clube';

  /// Chave estranjeira de [_TbUsuarios.id].
  String get idUsuario => 'id_usuario';

  /// Chave estranjeira de [_TbTiposPermissao.id].
  String get idPermissao => 'id_permissao';

  /// {@macro app._Tb.dataModificacao}
  String get dataAdmissao => 'data_admissao';
}

class _TbAtividades extends _Tb with _ColunaExcluir {
  const _TbAtividades();

  /// Nome da tabela para as atividades.
  @override
  String get tbNome => DbConst.kDbDataCollectionAtividades;

  /// Nome do campo para o ID da atividade.
  ///
  /// Os valores desse campo são do tipo [int].
  String get id => DbConst.kDbDataAtividadeKeyId;

  /// Chave estranjeira de [_TbClubes.id].
  String get idClube => DbConst.kDbDataAtividadeKeyIdClube;

  /// Nome do campo para o titulo da atividade.
  ///
  /// Os valores desse campo são do tipo [String].
  String get titulo => DbConst.kDbDataAtividadeKeyTitulo;

  /// Nome do campo para a descrição da atividade.
  ///
  /// Os valores desse campo são do tipo [String].
  String get descricao => DbConst.kDbDataAtividadeKeyDescricao;

  /// Chave estranjeira de [_TbUsuarios.id].
  String get idAutor => DbConst.kDbDataAtividadeKeyIdAutor;

  /// Nome do campo para o carimbo de data/hora da criação da atividade.
  ///
  /// {@macro app._Tb.dataModificacao}
  String get dataCriacao => DbConst.kDbDataAtividadeKeyDataCriacao;

  /// Nome do campo para o carimbo de data/hora da liberação da atividade.
  ///
  /// {@macro app._Tb.dataModificacao}
  String get dataLiberacao => DbConst.kDbDataAtividadeKeyDataLiberacao;

  /// Nome do campo para o carimbo de data/hora do prazo final para a entrega da atividade.
  ///
  /// {@macro app._Tb.dataModificacao}
  ///
  /// Será `NULL` se ainda não tiver sido liberada.
  String get dataEncerramento => DbConst.kDbDataAtividadeKeyDataEncerramento;
}

class _TbQuestaoAtividade extends _Tb with _ColunaExcluir {
  const _TbQuestaoAtividade();

  /// Nome da tabela para o relacionamento muitos para muitos entre as tabelas
  /// [Sql.tbQuestoesCaderno] e [Sql.tbAtividades].
  @override
  String get tbNome => 'questao_x_atividade';

  /// Os valores desse campo são do tipo [int].
  String get id => DbConst.kDbDataQuestaoAtividadeKeyId;

  /// Chave estranjeira de [_TbQuestoesCaderno.id].
  String get idQuestaoCaderno =>
      DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno;

  /// Chave estranjeira de [_TbAtividades.id].
  String get idAtividade => DbConst.kDbDataQuestaoAtividadeKeyIdAtividade;
}

class _TbRespostaQuestaoAtividade extends _Tb with _ColunaExcluir {
  const _TbRespostaQuestaoAtividade();

  /// Nome da tabela para as respostas dos usuários às questões das atividades.
  @override
  String get tbNome => DbConst.kDbDataCollectionRespostaQuestaoAtividade;

  /// Chave estranjeira de [_TbQuestaoAtividade.id].
  String get idQuestaoAtividade =>
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade;

  /// Chave estranjeira de [_TbUsuarios.id].
  String get idUsuario => DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario;

  /// Nome do campo para o sequencial da alternativa escolhida.
  ///
  /// Os valores desse campo são do tipo [int] ou `null`.
  String get resposta => DbConst.kDbDataRespostaQuestaoAtividadeKeyResposta;
}

class _TbRespostaQuestao extends _Tb with _ColunaExcluir {
  const _TbRespostaQuestao();

  /// Nome da tabela para as respostas dos usuários às questões das atividades.
  @override
  String get tbNome => DbConst.kDbDataCollectionRespostaQuestao;

  /// Chave estranjeira de [_TbQuestoes.id].
  String get idQuestao => DbConst.kDbDataRespostaQuestaoKeyIdQuestao;

  /// Chave estranjeira de [_TbUsuarios.id].
  String get idUsuario => DbConst.kDbDataRespostaQuestaoKeyIdUsuario;

  /// Nome do campo para o sequencial da alternativa escolhida.
  ///
  /// Os valores desse campo são do tipo [int] ou `null`.
  String get resposta => DbConst.kDbDataRespostaQuestaoKeyResposta;
}
