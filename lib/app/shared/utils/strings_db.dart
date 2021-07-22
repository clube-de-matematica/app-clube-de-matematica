/// O tipo com os dados de uma coleção (ou tabela) no banco de dados.
typedef DataCollection = List<DataDocument>;

/// O tipo com os dados de um documento (ou linha) no banco de dados.
typedef DataDocument = Map<String, dynamic>;

/// O valor [dynamic] pode ser [String] para [DbConst.kDbDataAssuntoKeyTitulo] ou [DataArvore]
/// para [DbConst.kDbDataAssuntoKeyArvore].
typedef DataAssunto = Map<String, dynamic>;

/// Super tipo para a lista com a hierarquia de tópicos para o assunto.
typedef DataArvore = List<String>;

/// O valor [dynamic] pode ser:
/// * [String] para [DbConst.kDbDataItemKeyId], [DbConst.kDbDataItemKeyGabarito] e
/// [DbConst.kDbDataItemKeyDificuldade];
/// * [int] para [DbConst.kDbDataItemKeyAno], [DbConst.kDbDataItemKeyNivel] e
/// [DbConst.kDbDataItemKeyIndice];
/// * [List]<[String]> para [DbConst.kDbDataItemKeyAssuntos] e [DbConst.kDbDataItemKeyEnunciado];
/// * [List]<[DataAlternativa]> para [DbConst.kDbDataItemKeyAlternativas]; ou
/// * [List]<[DataImagem]> para [DbConst.kDbDataItemKeyImagensEnunciado].
typedef DataItem = Map<String, dynamic>;

/// Super tipo para a alternativa do item (questão).
/// Possui as chaves:
/// * [DbConst.kDbDataAlternativaKeyAlternativa];
/// * [DbConst.kDbDataAlternativaKeyTipo]; e
/// * [DbConst.kDbDataAlternativaKeyValor].
typedef DataAlternativa = Map<String, String>;

/// Super tipo para as imagens usadas no enunciado e nas alternativas do item (questão).
/// O valor [dynamic] pode ser [String] para [DbConst.kDbDataImagemKeyNome] ou [int]
/// [DbConst.kDbDataImagemKeyLargura] e [DbConst.kDbDataImagemKeyAltura].
typedef DataImagem = Map<String, dynamic>;

/// Objeto que contem as constantes comuns aos bancos de dados local e remoto.
abstract class DbConst {
  /// Chave de [DataAlternativa] para o identificador da alternativa do item (questão).
  /// O identificador pode ser:
  /// * [kDbDataAlternativaKeyAlternativaValA];
  /// * [kDbDataAlternativaKeyAlternativaValB];
  /// * [kDbDataAlternativaKeyAlternativaValC];
  /// * [kDbDataAlternativaKeyAlternativaValD]; ou
  /// * [kDbDataAlternativaKeyAlternativaValE].
  static const kDbDataAlternativaKeyAlternativa = "alternativa";

  /// Identificador para a primeira alternativa do item (questão).
  static const kDbDataAlternativaKeyAlternativaValA = "A";

  /// Identificador para a segunda alternativa do item (questão).
  static const kDbDataAlternativaKeyAlternativaValB = "B";

  /// Identificador para a terceira alternativa do item (questão).
  static const kDbDataAlternativaKeyAlternativaValC = "C";

  /// Identificador para a quarta alternativa do item (questão).
  static const kDbDataAlternativaKeyAlternativaValD = "D";

  /// Identificador para a quinta alternativa do item (questão).
  static const kDbDataAlternativaKeyAlternativaValE = "E";

  /// Chave de [DataAlternativa] para o tipo da alternativa do item (questão).
  /// O tipo pode ser:
  /// * [kDbDataAlternativaKeyTipoValTexto]; ou
  /// * [kDbDataAlternativaKeyTipoValImagem].
  static const kDbDataAlternativaKeyTipo = "tipo";

  /// Tipo da alternativa do item (questão) quando esta deva exibir um texto.
  static const kDbDataAlternativaKeyTipoValTexto = "texto";

  /// Tipo da alternativa do item (questão) quando esta deva exibir uma imagem.
  static const kDbDataAlternativaKeyTipoValImagem = "imagem";

  /// Chave de [DataAlternativa] para o conteúdo da alternativa do item (questão).
  /// O conteúdo é do tipo [String].
  static const kDbDataAlternativaKeyValor = "valor";

/** 
 * ****************************************************************************************
**/

  /// Chave de [DataImagem] para o nome (com extenção) da imágem usada no enunciado ou na
  /// alternativa do item (questão).
  /// Os valores para essa chave são do tipo [String].
  static const kDbDataImagemKeyNome = "nome";

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

  /// Nome da coleção (ou tabela) que contem os assuntos ligados a cada item (questão).
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataAssunto]>.
  static const kDbDataCollectionAssuntos = "assuntos";

  /// Nome do campo para o assunto mais específico do item (questão).
  /// Os valores para esse campo são do tipo [String].
  static const kDbDataAssuntoKeyTitulo = "assunto";

  /// Nome do campo para a lista com a hierarquia de tópicos para o assunto.
  /// Este campo não contém o valor de [kDbDataAssuntoKeyTitulo].
  /// Os valores para esse campo são do tipo [DataArvore].
  static const kDbDataAssuntoKeyArvore = "arvore";

/** 
 * ****************************************************************************************
**/

  /// Nome da coleção (ou tabela) que contem os itens (questões).
  /// Ao ser retornado do banco de dados, tem a estrutura de um [List]<[DataItem]>.
  static const kDbDataCollectionItens = "itens";

  /// Nome do campo para o ID do item (questão).
  /// Os valores deste campo são do tipo [String] e estão no formato `2019PF1N1Q01`, onde:
  /// * `2019` é o ano de aplicação da prova;
  /// * `PF1` indica que a prova é da primeira fase;
  /// * `N1` indica que a prova é do nível 1;
  /// * `Q01` indica que trata-se do primeiro item do caderno.
  static const kDbDataItemKeyId = "id";

  /// Nome do campo para o ano de aplicação do item (questão).
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataItemKeyAno = "ano";

  /// Nome do campo para o nível da prova da OBMEP.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataItemKeyNivel = "nivel";

  /// Nome do campo para o número do item (questão) no caderno de prova.
  /// Os valores para esse campo são do tipo [int].
  static const kDbDataItemKeyIndice = "indice";

  /// Nome do campo para a lista com os assuntos mais específicos relacionados ao item (questão).
  /// Os valores para esse campo são do tipo [List]<[String]>.
  static const kDbDataItemKeyAssuntos = "assuntos";

  /// Nome do campo que contém a lista com as partes do enunciado do item (questão).
  /// A fragmentação é para indicar pontos de inserção de imágens.
  /// Os pontos de inserção podem ser [kDbStringImagemDestacada] ou [kDbStringImagemNaoDestacada].
  /// Os valores para esse campo são do tipo [List]<[String]>.
  static const kDbDataItemKeyEnunciado = "enunciado";

  /// Nome do campo para a lista com as alternativas do item (questão).
  /// Os valores para esse campo são do tipo [List]<[DataAlternativa]>.
  static const kDbDataItemKeyAlternativas = "alternativas";

  /// Nome do campo para o identificador da alternativa correta do item (questão).
  /// Os valores para esse campo podem ser:
  /// * [kDbDataAlternativaKeyAlternativaValA];
  /// * [kDbDataAlternativaKeyAlternativaValB];
  /// * [kDbDataAlternativaKeyAlternativaValC];
  /// * [kDbDataAlternativaKeyAlternativaValD]; ou
  /// * [kDbDataAlternativaKeyAlternativaValE].
  static const kDbDataItemKeyGabarito = "gabarito";

  /// Nome do campo para o nível de dificuldade do item (questão).
  /// Os valores para esse campo podem ser:
  /// * [kDbDataItemKeyDificuldadeValBaixa];
  /// * [kDbDataItemKeyDificuldadeValMedia]; ou
  /// * [kDbDataItemKeyDificuldadeValAlta].
  static const kDbDataItemKeyDificuldade = "dificuldade";

  /// Valor do campo [kDbDataItemKeyDificuldade] quando o nível de dificuldade do item (questão)
  /// é avaliado como baixo.
  static const kDbDataItemKeyDificuldadeValBaixa = "Baixa";

  /// Valor do campo [kDbDataItemKeyDificuldade] quando o nível de dificuldade do item (questão)
  /// é avaliado como moderado.
  static const kDbDataItemKeyDificuldadeValMedia = "Média";

  /// Valor do campo [kDbDataItemKeyDificuldade] quando o nível de dificuldade do item (questão)
  /// é avaliado como alto.
  static const kDbDataItemKeyDificuldadeValAlta = "Alta";

  /// Nome do campo para a lista com as imágens usadas no enunciado.
  /// Os valores para esse campo são do tipo [List]<[DataImagem]>.
  static const kDbDataItemKeyImagensEnunciado = "imagens_enunciado";

  /// Nome do campo para a referência à outro item (questão).
  /// Usado quando o mesmo item foi aplicado em mais de uma prova.
  /// Os valores desse campo são do tipo [String] e contém o ID do item referenciado.
  static const kDbDataItemKeyReferencia = "referencia";

/** 
 * ****************************************************************************************
**/

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem em uma nova linha.
  static const kDbStringImagemDestacada = "##nl##";

  /// Usado para indicar a parte do enunciado onde será inserida uma imágem na mesma linha.
  static const kDbStringImagemNaoDestacada = "##ml##";
}
