/// O tipo com os dados de uma coleção (ou tabela) no banco de dados.
typedef DataCollection = List<DataDocument>;

/// O tipo com os dados de um documento (ou linha) no banco de dados.
typedef DataDocument = Map<String, dynamic>;

/// O valor [dynamic] pode ser [String] para [DbConst.kDbDataAssuntoKeyTitulo] ou [DataHierarquia]
/// para [DbConst.kDbDataAssuntoKeyHierarquia].
typedef DataAssunto = Map<String, dynamic>;

/// Super tipo para a lista com a hierarquia de tópicos para o assunto.
typedef DataHierarquia = List<String>;

/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataQuestaoKeyId], [DbConst.kDbDataQuestaoKeyGabarito] e
/// [DbConst.kDbDataQuestaoKeyDificuldade];
/// * [int] para [DbConst.kDbDataQuestaoKeyAno], [DbConst.kDbDataQuestaoKeyNivel] e
/// [DbConst.kDbDataQuestaoKeyIndice];
/// * [List]<[String]> para [DbConst.kDbDataQuestaoKeyAssuntos] e [DbConst.kDbDataQuestaoKeyEnunciado];
/// * [List]<[DataAlternativa]> para [DbConst.kDbDataQuestaoKeyAlternativas]; ou
/// * [List]<[DataImagem]> para [DbConst.kDbDataQuestaoKeyImagensEnunciado].
typedef DataQuestao = Map<String, dynamic>;

/// Super tipo para a alternativa da questão.
/// As chaves podem ser:
/// * [DbConst.kDbDataAlternativaKeySequencial];
/// * [DbConst.kDbDataAlternativaKeyTipo]; e
/// * [DbConst.kDbDataAlternativaKeyConteudo].
typedef DataAlternativa = Map<String, String>;

/// Super tipo para as imagens usadas no enunciado e nas alternativas da questão.
/// O valor [dynamic] pode ser [String] para [DbConst.kDbDataImagemKeyBase64] ou [int]
/// [DbConst.kDbDataImagemKeyLargura] e [DbConst.kDbDataImagemKeyAltura].
typedef DataImagem = Map<String, dynamic>;

/// O objeto com as informações dos usuários usadas nos clubes.
/// As chaves podem ser:
/// * [DbConst.kDbDataUserKeyDisplayName];
/// * [DbConst.kDbDataUserKeyUid]; ou
/// * [DbConst.kDbDataUserKeyHashEmail].
typedef DataUser = Map<String, String>;

/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataClubeKeyNome] e [DbConst.kDbDataClubeKeyProprietario];
/// * [int] para [DbConst.kDbDataClubeKeyTimestamp]; ou
/// * [List]<[String]> para [DbConst.kDbDataClubeKeyAdministradores] e [DbConst.kDbDataClubeKeyMembros].
typedef DataClube = Map<String, dynamic>;

/// O objeto para a resposta do usuário a uma tarefa.
/// A chave é o ID da questão e o valor é o identificador da alternativa escolhida.
typedef DataResposta = Map<String, String>;

/// O objeto com o [DataResposta] de todos os membros do clube à tarefa.
/// A chave é o UID do membro e o valor é o objeto [DataResposta] com as respostas desse
/// membro.
typedef DataRespostas = Map<String, DataResposta>;

/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataTarefaKeyAutor] e [DbConst.kDbDataTarefaKeyIdClube];
/// * [int] para [DbConst.kDbDataTarefaKeyTimestamp]; ou
/// * [List]<[String]> para [DbConst.kDbDataTarefaKeyIdItens].
typedef DataTarefa = Map<String, dynamic>;

/// Objeto que contem as constantes comuns aos bancos de dados local e remoto.
abstract class DbConst {
  /// Chave de [DataAlternativa] para o identificador ordinal da alternativa da questão. 
  /// O primeiro valor é 0 (zero).
  /// O identificador é do tipo [int].
  static const kDbDataAlternativaKeySequencial = "sequencial";

  /// Chave de [DataAlternativa] para o tipo da alternativa da questão.
  /// O tipo é do tipo [int], a saber:
  /// * [kDbDataAlternativaKeyTipoValTexto]; ou
  /// * [kDbDataAlternativaKeyTipoValImagem].
  static const kDbDataAlternativaKeyTipo = "id_tipo";

  /// Tipo da alternativa da questão quando esta deva exibir um texto.
  static const kDbDataAlternativaKeyTipoValTexto = 0;

  /// Tipo da alternativa da questão quando esta deva exibir uma imagem.
  static const kDbDataAlternativaKeyTipoValImagem = 1;

  /// Chave de [DataAlternativa] para o conteúdo da alternativa da questão.
  /// O conteúdo é do tipo [String].
  /// * Se [kDbDataAlternativaKeyTipo] = [kDbDataAlternativaKeyTipoValTexto], contém o texto da 
  /// alternativa (pode conter um código LaTex. 
  /// * Se [kDbDataAlternativaKeyTipo] = [kDbDataAlternativaKeyTipoValImagem], contém a string 
  /// base64 da imagem.
  static const kDbDataAlternativaKeyConteudo = "conteudo";

/** 
 * ****************************************************************************************
**/

  /// Chave de [DataImagem] para a codificação em string base64 da imágem usada no enunciado 
  /// ou na alternativa do item (questão).
  /// Os valores para essa chave são do tipo [String].
  static const kDbDataImagemKeyBase64 = "base64";

  /// Chave de [DataImagem] para a largura da imágem usada no enunciado ou na
  /// alternativa do item (questão).
  /// Os valores para essa chave são do tipo [int].
  static const kDbDataImagemKeyLargura = "largura";

  /// Chave de [DataImagem] para a altura da imágem usada no enunciado ou na
  /// alternativa do item (questão).
  /// Os valores para essa chave são do tipo [int].
  static const kDbDataImagemKeyAltura = "altura";

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) que contém os assuntos ligados a cada questão.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataAssunto]>.
  static const kDbDataCollectionAssuntos = "assuntos";

  /// Nome do campo para o ID do assunto mais específico da questão.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataAssuntoKeyId = "id";

  /// Nome do campo para o assunto mais específico da questão.
  /// Os valores para esse campo são do tipo [String].
  static const kDbDataAssuntoKeyTitulo = "assunto";

  /// Nome do campo para a lista com a hierarquia de tópicos para o assunto, iniciando pela 
  /// unidade. A lista não contém o assunto. Será uma lista vazia se o assunto for uma unidade.
  /// Os valores para esse campo são do tipo [DataHierarquia].
  static const kDbDataAssuntoKeyHierarquia = "hierarquia";

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) que contém as questões.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataQuestao]>.
  static const kDbDataCollectionQuestoes = "questoes";

  /// Nome do campo para o ID da questão.
  /// Os valores deste campo são do tipo [String] e estão no formato `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se da primeira questão do caderno.
  static const kDbDataQuestaoKeyId = "id";

  /// Nome do campo para o ano de aplicação da questão.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyAno = "ano";

  /// Nome do campo para o nível da prova da OBMEP.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyNivel = "nivel";

  /// Nome do campo para o número da questão no caderno de prova.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataQuestaoKeyIndice = "indice";

  /// Nome do campo para a lista com o ID dos assuntos mais específicos relacionados à questão.
  /// Os valores para esse campo são do tipo [List]<[int]>.
  static const kDbDataQuestaoKeyAssuntos = "assuntos";

  /// Nome do campo que contém a lista com as partes do enunciado da questão.
  /// A fragmentação é para indicar pontos de inserção de imágens.
  /// Os pontos de inserção podem ser [kDbStringImagemDestacada] ou [kDbStringImagemNaoDestacada].
  /// Os valores para esse campo são do tipo [List]<[String]>.
  static const kDbDataQuestaoKeyEnunciado = "enunciado";

  /// Nome do campo para a lista com as alternativas da questão.
  /// Os valores para esse campo são do tipo [List]<[DataAlternativa]>.
  static const kDbDataQuestaoKeyAlternativas = "alternativas";

  /// Nome do campo para o identificador ordinal da alternativa correta da questão.
  /// Os valores para esse campo devem corresponder a um [kDbDataAlternativaKeySequencial] 
  /// entre as alternativas da questão.
  static const kDbDataQuestaoKeyGabarito = "gabarito";

  /// Nome do campo para a lista com as imágens usadas no enunciado.
  /// Os valores para esse campo são do tipo [List]<[DataImagem]>.
  static const kDbDataQuestaoKeyImagensEnunciado = "imagens_enunciado";

/** 
 * ****************************************************************************************
**/

  /// Nome da chave que armazena o nome do usuário em [DataUser].
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyDisplayName = "display_name";

  /// Nome da chave que armazena o UID do usuário no [Firebase] em [DataUser].
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyUid = "uid";

  /// Nome da chave que armazena o hash do email do usuário em [DataUser].
  /// Esse campo possiblita localizar o usuário caso haja alteração no seu UID.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataUserKeyHashEmail = "uid";

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) que contem os clubes.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataClube]>.
  static const kDbDataCollectionClubes = "clubes";

  /// Nome do campo que contém o carimbo de data/hora da criação do clube.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataClubeKeyTimestamp = "timestamp";

  /// Nome do campo que contém o código aleatório que compões os dois últimos dígitos do ID
  /// base 62 usado para ingresso no clube.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyRandomCode = "random_code";

  /// Nome do campo que contém o nome do clube.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataClubeKeyNome = "nome";

  /// Nome do campo que contém o email do proprietário do clube.
  /// Os valores desse campo são do tipo [DataUser].
  static const kDbDataClubeKeyProprietario = "proprietario";

  /// Nome do campo que contém uma lista com o email de cada administrador do clube.
  /// Os valores desse campo são do tipo [List]<[DataUser]>.
  static const kDbDataClubeKeyAdministradores = "administradores";

  /// Nome do campo que contém uma lista com o email de cada membro do clube.
  /// Os valores desse campo são do tipo [List]<[DataUser]>.
  static const kDbDataClubeKeyMembros = "membros";

  /// Nome do campo que contém um inteiro que intica o nível de privacidade do clube.
  /// * Se 0, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se 1, o clube é privado. O ingresso depende da permissão de um administrador.
  static const kDbDataClubeKeyPrivacidade = "privacidade";

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) que contem as tarefas.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataTarefa]>.
  static const kDbDataCollectionTarefas = "tarefas";

  /// Nome do campo que contém o carimbo de data/hora da criação da tarefa.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataTarefaKeyTimestamp = "timestamp";

  /// Nome do campo que contém o objeto [DataUser] (sem o campo
  /// [DbConst.kDbDataUserKeyDisplayName]) do autor da tarefa.
  /// Os valores desse campo são do tipo [DataUser].
  static const kDbDataTarefaKeyAutor = "autor";

  /// Nome do campo que contém o ID do clube ao qual a tarefa pertence.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataTarefaKeyIdClube = "id_clube";

  /// Nome do campo que contém uma lista com os ID's das questões que pertencem à tarefa.
  /// Os valores desse campo são do tipo [List]<[String]>.
  static const kDbDataTarefaKeyIdItens = "id_Itens";

  /// Nome do campo que contém o objeto [DataRespostas] associado à tarefa.
  /// Os valores desse campo são do tipo [DataRespostas].
  static const kDbDataTarefaKeyRespostas = "respostas";

/** 
 * ****************************************************************************************
**/

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem em uma nova linha.
  static const kDbStringImagemDestacada = "##nl##";

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem na mesma linha.
  static const kDbStringImagemNaoDestacada = "##ml##";
}
