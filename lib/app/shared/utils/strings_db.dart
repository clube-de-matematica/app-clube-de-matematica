/// O objeto com os dados de uma coleção (ou tabela) no banco de dados.
typedef DataCollection = List<DataDocument>;

/// O objeto com os dados de um documento (ou linha) no banco de dados.
typedef DataDocument = Map<String, dynamic>;

/// O objeto com os dados de um assunto. O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataAssuntoKeyId],
/// * [String] para [DbConst.kDbDataAssuntoKeyTitulo] ou
/// * [DataHierarquia] para [DbConst.kDbDataAssuntoKeyHierarquia].
typedef DataAssunto = Map<String, dynamic>;

/// O objeto para a lista com a hierarquia de tópicos para o assunto.
typedef DataHierarquia = List<int>;

/// O objeto com os dados de uma questão. O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataQuestaoKeyIdAlfanumerico] e [DbConst.kDbDataQuestaoKeyGabarito];
/// * [int] para [DbConst.kDbDataQuestaoKeyId], [DbConst.kDbDataQuestaoKeyAno], 
/// [DbConst.kDbDataQuestaoKeyNivel] e [DbConst.kDbDataQuestaoKeyIndice];
/// * [List]<[int]> para [DbConst.kDbDataQuestaoKeyAssuntos];
/// * [List]<[String]> para [DbConst.kDbDataQuestaoKeyEnunciado];
/// * [List]<[DataAlternativa]> para [DbConst.kDbDataQuestaoKeyAlternativas]; ou
/// * [List]<[DataImagem]> para [DbConst.kDbDataQuestaoKeyImagensEnunciado].
typedef DataQuestao = Map<String, dynamic>;

/// O objeto com os dados de uma alternativa em uma questão.
/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataAlternativaKeyConteudo], ou
/// * [int] para [DbConst.kDbDataAlternativaKeyIdQuestao],
/// [DbConst.kDbDataAlternativaKeySequencial] e [DbConst.kDbDataAlternativaKeyTipo].
///
/// Se o valor em [DbConst.kDbDataAlternativaKeyTipo] for
/// [DbConst.kDbDataAlternativaKeyTipoValImagem], o valor em
/// [DbConst.kDbDataAlternativaKeyConteudo] será um [DataImagem] codificado para string json.
typedef DataAlternativa = Map<String, dynamic>;

/// O objeto com os dados de uma imagem usada no enunciado ou em uma alternativa da questão.
/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataImagemKeyBase64] ou
/// * [double] para [DbConst.kDbDataImagemKeyLargura] e [DbConst.kDbDataImagemKeyAltura].
typedef DataImagem = Map<String, dynamic>;

/// O objeto com os dados de um usuário.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataUserKeyId]; ou
/// * [String] para [DbConst.kDbDataUserKeyNome], [DbConst.kDbDataUserKeyFoto] e
/// [DbConst.kDbDataUserKeyEmail].
typedef DataUsuario = Map<String, dynamic>;

/// O objeto com os dados de um usuário de clube.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataUserClubeKeyIdUsuario], [DbConst.kDbDataUserClubeKeyIdClube] e
/// [DbConst.kDbDataUserClubeKeyIdPermissao]; ou
/// * [String] para [DbConst.kDbDataUserClubeKeyNome], [DbConst.kDbDataUserClubeKeyFoto] e
/// [DbConst.kDbDataUserClubeKeyEmail].
typedef DataUsuarioClube = Map<String, dynamic>;

/// O objeto com os dados de um clube.
/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataClubeKeyNome], [DbConst.kDbDataClubeKeyDescricao],
/// [DbConst.kDbDataClubeKeyCapa] e [DbConst.kDbDataClubeKeyCodigo];
/// * [int] para [DbConst.kDbDataClubeKeyId] e [DbConst.kDbDataClubeKeyDataCriacao];
/// * [bool] para [DbConst.kDbDataClubeKeyPrivado] e [DbConst.kDbDataClubeKeyExcluir]; ou
/// * [List]<[DataUsuarioClube]> para [DbConst.kDbDataClubeKeyUsuarios].
typedef DataClube = Map<String, dynamic>;

/// O objeto com os dados que vinculam uma questão a uma atividade.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataQuestaoAtividadeKeyId] e
/// [DbConst.kDbDataQuestaoAtividadeKeyIdAtividade];
/// * [bool] para [DbConst.kDbDataQuestaoAtividadeKeyExcluir]; ou
/// * [String] para [DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno].
typedef DataQuestaoAtividade = Map<String, dynamic>;

/// O objeto com os dados de uma resposta de um usuário a uma atividade.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade],
///  [DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario] e
///  [DbConst.kDbDataRespostaQuestaoAtividadeKeyResposta]; ou
/// * [bool] para [DbConst.kDbDataRespostaQuestaoAtividadeKeyExcluir].
typedef DataRespostaQuestaoAtividade = Map<String, dynamic>;

/// O objeto com os dados de uma atividade.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataAtividadeKeyId], [DbConst.kDbDataAtividadeKeyIdClube],
/// [DbConst.kDbDataAtividadeKeyIdAutor], [DbConst.kDbDataAtividadeKeyDataCriacao]
/// [DbConst.kDbDataAtividadeKeyDataLiberacao] e
/// [DbConst.kDbDataAtividadeKeyDataEncerramento];
/// * [String] para [DbConst.kDbDataAtividadeKeyTitulo] e
/// [DbConst.kDbDataAtividadeKeyDescricao];
/// * [List]<[String]> para [DbConst.kDbDataAtividadeKeyQuestoes];
/// * [bool] para [DbConst.kDbDataAtividadeKeyExcluir];  ou
/// * [List]<[DataRespostaQuestaoAtividade]> para [DbConst.kDbDataAtividadeKeyRespostas].
typedef DataAtividade = Map<String, dynamic>;

/// O objeto com os dados de uma resposta de um usuário a uma atividade.
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataRespostaQuestaoKeyIdQuestao],
/// [DbConst.kDbDataRespostaQuestaoKeyIdUsuario] e
/// [DbConst.kDbDataRespostaQuestaoKeyResposta]; ou
/// * [bool] para [DbConst.kDbDataRespostaQuestaoKeyExcluir]; .
typedef DataRespostaQuestao = Map<String, dynamic>;

/// Objeto que contém as constantes comuns aos bancos de dados local e remoto.
abstract class DbConst {
  /// Chave de [DataDocument] para a data da última modificação do documentos (ou registros).
  static const kDbDataDocumentKeyDataModificacao = 'data_modificacao';

  /// {@template app.DbConst.kDbDataDocumentKeyExcluir}
  /// Chave para indicar se o documento (ou registro) está marcado como excluído.
  /// {@endtemplate}
  /// Usada em [DataClube], [DataAtividade], [DataQuestaoAtividade],
  /// [DataRespostaQuestaoAtividade] e [DataRespostaQuestao].
  static const kDbDataDocumentKeyExcluir = 'excluir';

  /// Chave de [DataAlternativa] para o ID da questão.
  /// O ID é do tipo [int].
  static const kDbDataAlternativaKeyIdQuestao = 'id_questao';

  /// Chave de [DataAlternativa] para o identificador ordinal da alternativa da questão.
  /// O primeiro valor é 0 (zero).
  /// O identificador é do tipo [int].
  static const kDbDataAlternativaKeySequencial = 'sequencial';

  /// Chave de [DataAlternativa] para o tipo da alternativa da questão.
  /// O tipo é do tipo [int], a saber:
  /// * [kDbDataAlternativaKeyTipoValTexto]; ou
  /// * [kDbDataAlternativaKeyTipoValImagem].
  static const kDbDataAlternativaKeyTipo = 'id_tipo';

  /// Tipo da alternativa da questão quando esta deva exibir um texto.
  static const kDbDataAlternativaKeyTipoValTexto = 0;

  /// Tipo da alternativa da questão quando esta deva exibir uma imagem.
  static const kDbDataAlternativaKeyTipoValImagem = 1;

  /// Chave de [DataAlternativa] para o conteúdo da alternativa da questão.
  /// O conteúdo é do tipo [String].
  /// * Se [kDbDataAlternativaKeyTipo] correspode a [kDbDataAlternativaKeyTipoValTexto],
  /// contém o texto da alternativa (pode conter um código LaTex).
  /// * Se [kDbDataAlternativaKeyTipo] correspode a [kDbDataAlternativaKeyTipoValImagem],
  /// contém a codificação json de [DataImagem].
  static const kDbDataAlternativaKeyConteudo = 'conteudo';

/** 
 * ****************************************************************************************
**/

  /// Chave de [DataImagem] para a codificação em string base64 da imágem usada no enunciado
  /// ou na alternativa do item (questão).
  /// Os valores para essa chave são do tipo [String].
  static const kDbDataImagemKeyBase64 = 'base64';

  /// Chave de [DataImagem] para a largura da imágem usada no enunciado ou na
  /// alternativa do item (questão).
  /// Os valores para essa chave são do tipo [double].
  static const kDbDataImagemKeyLargura = 'largura';

  /// Chave de [DataImagem] para a altura da imágem usada no enunciado ou na
  /// alternativa do item (questão).
  /// Os valores para essa chave são do tipo [double].
  static const kDbDataImagemKeyAltura = 'altura';

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para os assuntos ligados a cada questão.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataAssunto]>.
  static const kDbDataCollectionAssuntos = 'assuntos';

  /// Nome do campo para o ID do assunto mais específico da questão.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataAssuntoKeyId = 'id';

  /// Nome do campo para o assunto mais específico da questão.
  /// Os valores para esse campo são do tipo [String].
  static const kDbDataAssuntoKeyTitulo = 'assunto';

  /// Nome do campo para a lista com a hierarquia de tópicos para o assunto, iniciando pela
  /// unidade. A lista não contém o assunto. Será uma lista vazia se o assunto for uma unidade.
  /// Os valores para esse campo são do tipo [DataHierarquia].
  static const kDbDataAssuntoKeyHierarquia = 'hierarquia';

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para as questões.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataQuestao]>.
  static const kDbDataCollectionQuestoes = 'questoes';

  /// Nome do campo para o ID alfanumérico da questão.
  /// Os valores deste campo são do tipo [String] e estão no formato `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se da primeira questão do caderno.
  static const kDbDataQuestaoKeyIdAlfanumerico = 'id_questao_caderno';

  /// Nome do campo para o ID numérico da questão.
  /// Questões aplicadas em mais de um caderno têm [kDbDataQuestaoKeyIdAlfanumerico] diferentes, 
  /// mas o mesmo [kDbDataQuestaoKeyId].
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyId = 'id';

  /// Nome do campo para o ano de aplicação da questão.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyAno = 'ano';

  /// Nome do campo para o nível da prova da OBMEP.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyNivel = 'nivel';

  /// Nome do campo para o número da questão no caderno de prova.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyIndice = 'indice';

  /// Nome do campo para a lista com o ID dos assuntos mais específicos relacionados à questão.
  /// Os valores para esse campo são do tipo [List]<[int]>.
  static const kDbDataQuestaoKeyAssuntos = 'assuntos';

  /// Nome do campo para a lista com as partes do enunciado da questão.
  /// A fragmentação é para indicar pontos de inserção de imágens.
  /// Os pontos de inserção podem ser [kDbStringImagemDestacada] ou [kDbStringImagemNaoDestacada].
  /// Os valores para esse campo são do tipo [List]<[String]>.
  static const kDbDataQuestaoKeyEnunciado = 'enunciado';

  /// Nome do campo para a lista com as alternativas da questão.
  /// Os valores para esse campo são do tipo [List]<[DataAlternativa]>.
  static const kDbDataQuestaoKeyAlternativas = 'alternativas';

  /// Nome do campo para o identificador ordinal da alternativa correta da questão.
  /// Os valores para esse campo devem corresponder a um [kDbDataAlternativaKeySequencial]
  /// entre as alternativas da questão.
  static const kDbDataQuestaoKeyGabarito = 'gabarito';

  /// Nome do campo para a lista com as imágens usadas no enunciado.
  /// Os valores para esse campo são do tipo [List]<[DataImagem]>.
  static const kDbDataQuestaoKeyImagensEnunciado = 'imagens_enunciado';

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para os usuários.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataUsuario]>.
  static const kDbDataCollectionUsuarios = 'usuarios';

  /// Nome do campo para o nome do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyNome = 'nome';

  /// Nome do campo para o ID do usuário.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataUserKeyId = 'id';

  /// Nome do campo para o email do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyEmail = 'email';

  /// Nome do campo para a string base64 da foto de perfil do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyFoto = 'foto';

/** 
 * ****************************************************************************************
**/

/** 
 * ****************************************************************************************
**/

  /// Nome do campo para o nome do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserClubeKeyNome = 'nome';

  /// Nome do campo para o ID do usuário.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataUserClubeKeyIdUsuario = 'id_usuario';

  /// Nome do campo para o email do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserClubeKeyEmail = 'email';

  /// Nome do campo para a string base64 da foto de perfil do usuário.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserClubeKeyFoto = 'foto';

  /// Nome do campo para o ID do clube ao qual o usuário está vinculado.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataUserClubeKeyIdClube = 'id_clube';

  /// Nome do campo para o ID da permissao do usuário do usuário.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataUserClubeKeyIdPermissao = 'id_permissao';

  /// Valor de [kDbDataUserClubeKeyIdPermissao] para proprietário.
  static const kDbDataUserClubeKeyIdPermissaoProprietario = 0;

  /// Valor de [kDbDataUserClubeKeyIdPermissao] para administrador.
  static const kDbDataUserClubeKeyIdPermissaoAdministrador = 1;

  /// Valor de [kDbDataUserClubeKeyIdPermissao] para membro.
  static const kDbDataUserClubeKeyIdPermissaoMembro = 2;

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para os clubes.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataClube]>.
  static const kDbDataCollectionClubes = 'clubes';

  /// Nome do campo para o ID do usuário.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataClubeKeyId = 'id';

  /// Nome do campo para o carimbo de data/hora da criação do clube.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataClubeKeyDataCriacao = 'data_criacao';

  /// Nome do campo para o nome do clube.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyNome = 'nome';

  /// Uma pequena descrição sobre o clube.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyDescricao = 'descricao';

  /// Nome do campo para uma lista com os dados dos usuários do clube.
  /// Os valores desse campo são do tipo [List]<[DataUsuarioClube]>.
  static const kDbDataClubeKeyUsuarios = 'usuarios';

  /// Nome do campo para o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  static const kDbDataClubeKeyPrivado = 'privado';

  /// Nome do campo para a imágem ou a cor de capa.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyCapa = 'capa';

  /// Nome do campo para o ID base62 de acesso ao clube.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyCodigo = 'codigo';

  /// {@macro app.DbConst.kDbDataDocumentKeyExcluir}
  static const kDbDataClubeKeyExcluir = kDbDataDocumentKeyExcluir;

/** 
 * ****************************************************************************************
**/

  /// Nome do campo para o ID do registro de relacionamento entre uma questão e uma atividade.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataQuestaoAtividadeKeyId = 'id';

  /// Nome do campo para o ID da questão incluída em uma determinada atividade.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataQuestaoAtividadeKeyIdQuestaoCaderno =
      'id_questao_caderno';

  /// Nome do campo para o ID da atividade ao qual a questão foi incluída.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataQuestaoAtividadeKeyIdAtividade = 'id_atividade';

  /// {@macro app.DbConst.kDbDataDocumentKeyExcluir}
  static const kDbDataQuestaoAtividadeKeyExcluir = kDbDataDocumentKeyExcluir;

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para as respostas dos membros dos clubes às atividades.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataRespostaQuestaoAtividade]>.
  static const kDbDataCollectionRespostaQuestaoAtividade =
      'resposta_x_questao_x_atividade';

  /// Nome do campo para o ID do registro de relacionamento entre uma questão e uma atividade.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade =
      'id_questao_x_atividade';

  /// Nome do campo para o ID do usuário ao qual a resposta pertence.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataRespostaQuestaoAtividadeKeyIdUsuario = 'id_usuario';

  /// Nome do campo para o sequencial da alternativa escolhida.
  /// Os valores desse campo são do tipo [int] ou `null`.
  static const kDbDataRespostaQuestaoAtividadeKeyResposta = 'resposta';

  /// {@macro app.DbConst.kDbDataDocumentKeyExcluir}
  static const kDbDataRespostaQuestaoAtividadeKeyExcluir =
      kDbDataDocumentKeyExcluir;

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para as atividades.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataAtividade]>.
  static const kDbDataCollectionAtividades = 'atividades';

  /// Nome do campo para o ID da atividade.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataAtividadeKeyId = 'id';

  /// Nome do campo para o ID do clube ao qual a atividade pertence.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataAtividadeKeyIdClube = 'id_clube';

  /// Nome do campo para o titulo da atividade.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataAtividadeKeyTitulo = 'titulo';

  /// Nome do campo para a descrição da atividade.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataAtividadeKeyDescricao = 'descricao';

  /// Nome do campo para o ID do autor da atividade.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataAtividadeKeyIdAutor = 'id_autor';

  /// Nome do campo para o carimbo de data/hora da criação da atividade.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataAtividadeKeyDataCriacao = 'data_criacao';

  /// Nome do campo para o carimbo de data/hora da liberação da atividade.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataAtividadeKeyDataLiberacao = 'data_liberacao';

  /// Nome do campo para o carimbo de data/hora do prazo final para a entrega da atividade.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  /// Será `NULL` se ainda não tiver sido liberada.
  static const kDbDataAtividadeKeyDataEncerramento = 'data_encerramento';

  /// Nome do campo para uma lista com os objetos [DataQuestaoAtividade] de cada questão da
  /// atividades.
  /// Os valores desse campo são do tipo [List]<[DataQuestaoAtividade]>.
  static const kDbDataAtividadeKeyQuestoes = 'questoes';

  /// Nome do campo para uma lista com as respostas dos usuários às questões da atividades.
  /// Os valores desse campo são do tipo [List]<[DataResposta]>.
  static const kDbDataAtividadeKeyRespostas = 'respostas';

  /// {@macro app.DbConst.kDbDataDocumentKeyExcluir}
  static const kDbDataAtividadeKeyExcluir = kDbDataDocumentKeyExcluir;

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para as respostas (não vinculadas a atividades) dos usuários
  /// às questões.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataRespostaQuestao]>.
  static const kDbDataCollectionRespostaQuestao = 'resposta_x_questao';

  /// Nome do campo para o ID da questão à qual a resposta pertence.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataRespostaQuestaoKeyIdQuestao = 'id_questao';

  /// Nome do campo para o ID do usuário ao qual a resposta pertence.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataRespostaQuestaoKeyIdUsuario = 'id_usuario';

  /// Nome do campo para o sequencial da alternativa escolhida.
  /// Os valores desse campo são do tipo [int] ou `null`.
  static const kDbDataRespostaQuestaoKeyResposta = 'resposta';

  /// {@macro app.DbConst.kDbDataDocumentKeyExcluir}
  static const kDbDataRespostaQuestaoKeyExcluir = kDbDataDocumentKeyExcluir;

/** 
 * ****************************************************************************************
**/

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem em uma nova linha.
  static const kDbStringImagemDestacada = '##nl##';

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem na mesma linha.
  static const kDbStringImagemNaoDestacada = '##ml##';
}
