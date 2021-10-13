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
/// * [String] para [DbConst.kDbDataQuestaoKeyId] e [DbConst.kDbDataQuestaoKeyGabarito];
/// * [int] para [DbConst.kDbDataQuestaoKeyAno], [DbConst.kDbDataQuestaoKeyNivel] e
/// [DbConst.kDbDataQuestaoKeyIndice];
/// * [List]<[int]> para [DbConst.kDbDataQuestaoKeyAssuntos]; 
/// * [List]<[String]> para [DbConst.kDbDataQuestaoKeyEnunciado];
/// * [List]<[DataAlternativa]> para [DbConst.kDbDataQuestaoKeyAlternativas]; ou
/// * [List]<[DataImagem]> para [DbConst.kDbDataQuestaoKeyImagensEnunciado].
typedef DataQuestao = Map<String, dynamic>;

/// O objeto com os dados de uma alternativa em uma questão. 
/// O valor [dynamic] pode ser: 
/// * [String] para [DbConst.kDbDataAlternativaKeyIdQuestao] e 
/// [DbConst.kDbDataAlternativaKeyConteudo], ou 
/// * [int] para [DbConst.kDbDataAlternativaKeySequencial] e 
/// [DbConst.kDbDataAlternativaKeyTipo].
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
typedef DataUser = Map<String, dynamic>;
















/// O objeto com os dados de um clube. 
/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataClubeKeyNome] e [DbConst.kDbDataClubeKeyProprietario];
/// * [int] para [DbConst.kDbDataClubeKeyId] e [DbConst.kDbDataClubeKeyDataCriacao]; 
/// * [bool] para [DbConst.kDbDataClubeKeyPrivado]; ou
/// * [List]<[String]> para [DbConst.kDbDataClubeKeyAdministradores] e [DbConst.kDbDataClubeKeyMembros].
typedef DataClube = Map<String, dynamic>;

/// O objeto com os dados de uma resposta de um usuário a uma tarefa.
/// A chave é o ID da questão e o valor é o identificador da alternativa escolhida.
typedef DataResposta = Map<String, int>;

/// O objeto com os dados das respostas de todos os membros de um clube a uma tarefa.
/// A chave é o ID do membro e o valor é o objeto [DataResposta] com as respostas desse membro.
typedef DataRespostas = Map<int, DataResposta>;

/// O objeto com os dados de uma tarefa. 
/// O valor [dynamic] pode ser:
/// * [int] para [DbConst.kDbDataTarefaKeyAutor], [DbConst.kDbDataTarefaKeyIdClube] e 
/// [DbConst.kDbDataTarefaKeyTimestamp]; ou
/// * [List]<[String]> para [DbConst.kDbDataTarefaKeyIdQuestao].
typedef DataTarefa = Map<String, dynamic>;

/// Objeto que contém as constantes comuns aos bancos de dados local e remoto.
abstract class DbConst {
  /// Chave de [DataAlternativa] para o ID da questão.
  /// O ID é do tipo [String].
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
  /// * Se [kDbDataAlternativaKeyTipo] = [kDbDataAlternativaKeyTipoValTexto], contém o texto da
  /// alternativa (pode conter um código LaTex.
  /// * Se [kDbDataAlternativaKeyTipo] = [kDbDataAlternativaKeyTipoValImagem], contém a string
  /// base64 da imagem.
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

  /// Nome do campo para o ID da questão.
  /// Os valores deste campo são do tipo [String] e estão no formato `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se da primeira questão do caderno.
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
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataUser]>.
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

  /// Nome do campo para o ID do proprietário do clube.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataClubeKeyProprietario = 'proprietario';

  /// Nome do campo para uma lista com o ID de cada administrador do clube.
  /// Os valores desse campo são do tipo [List]<[int]>.
  static const kDbDataClubeKeyAdministradores = 'administradores';

  /// Nome do campo para uma lista com o ID de cada membro do clube, excluindo-se o 
  /// proprietário e os administradores.
  /// Os valores desse campo são do tipo [List]<[int]>.
  static const kDbDataClubeKeyMembros = 'membros';

  /// Nome do campo para o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  static const kDbDataClubeKeyPrivado = 'privado';

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) para as tarefas.
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataTarefa]>.
  static const kDbDataCollectionTarefas = 'tarefas';

  /// Nome do campo para o ID da tarefa.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataTarefaKeyId = 'id';

  /// Nome do campo para o ID do clube ao qual a tarefa pertence.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataTarefaKeyIdClube = 'id_clube';

  /// Nome do campo para o nome da tarefa.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataTarefaKeyNome = 'nome';

  /// Nome do campo para a descrição da tarefa.
  /// Os valores desse campo são do tipo [String].
  static const kDbDataTarefaKeyDescricao = 'descricao';

  /// Nome do campo para o ID do autor da tarefa.
  /// Os valores desse campo são do tipo [int].
  static const kDbDataTarefaKeyIdAutor = 'id_autor';

  /// Nome do campo para o carimbo de data/hora da criação da tarefa.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataTarefaKeyDataCriacao = 'data_criacao';

  /// Nome do campo para o carimbo de data/hora da publicação da tarefa.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataTarefaKeyDataPublicacao = 'data_publicacao';

  /// Nome do campo para o carimbo de data/hora do prazo final para a entrega da tarefa.
  /// Os valores desse campo são de algum tipo que possa ser convertido no número de
  /// milisegundos a partir de 0001-01-01T00:00:00Z, geralmente um [int] com esse número.
  static const kDbDataTarefaKeyDataFinal = 'data_final';

/** 
 * ****************************************************************************************
**/

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem em uma nova linha.
  static const kDbStringImagemDestacada = '##nl##';

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem na mesma linha.
  static const kDbStringImagemNaoDestacada = '##ml##';
}
