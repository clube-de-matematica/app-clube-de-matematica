///Contém os assuntos ligados a cada questão.
const DB_FIRESTORE_COLEC_ASSUNTOS = "assuntos";

///Assunto mais específico da questão.
const DB_FIRESTORE_DOC_ASSUNTO_TITULO = "assunto";

///Contém uma lista com a hierarquia de tópicos para o assunto.
const DB_FIRESTORE_DOC_ASSUNTO_ARVORE = "arvore";

///Banco de questões.
const DB_FIRESTORE_COLEC_ITENS = "itens";

///ID no formato 2019PF1N1Q01.
const DB_FIRESTORE_DOC_ITEM_ID = "id";

///Ano de aplicação da questão.
const DB_FIRESTORE_DOC_ITEM_ANO = "ano";

///Nível da prova da OBMEP.
const DB_FIRESTORE_DOC_ITEM_NIVEL = "nivel";

///Número da questão no caderno de prova.
const DB_FIRESTORE_DOC_ITEM_INDICE = "indice";

///Contém uma lista com os assuntos mais específicos da questão.
const DB_FIRESTORE_DOC_ITEM_ASSUNTOS = "assuntos";

///Contém uma lista com as partes do enunciado. A fragmentação é para indicar pontos de
///inserção de imágens.
const DB_FIRESTORE_DOC_ITEM_ENUNCIADO = "enunciado";

///Contém uma lista com cinco mapas no formato
///'{item: "A"/"B"/"C"/"D"/"E",
///  tipo: "texto"/"imagem",
///  valor: "texto do item"/"nome da imágem"}'.
///Cada mapa contém informações de um item.
const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS = "alternativas";

///Contém o identificador da alternativa.
const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA = "alternativa";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA_A = "A";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA_B = "B";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA_C = "C";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA_D = "D";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA_E = "E";

///Contém o tipo do item.
const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO = "tipo";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO = "texto";

const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM = "imagem";

///Contém o conteúdo do item.
const DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR = "valor";

///Uma das opções: "A", "B", "C", "D" ou "E".
const DB_FIRESTORE_DOC_ITEM_GABARITO = "gabarito";

///Uma das opções: "Baixa", "Média" ou "Alta".
const DB_FIRESTORE_DOC_ITEM_DIFICULDADE = "dificuldade";

const DB_FIRESTORE_DOC_ITEM_DIFICULDADE_BAIXA = "Baixa";

const DB_FIRESTORE_DOC_ITEM_DIFICULDADE_MEDIA = "Média";

const DB_FIRESTORE_DOC_ITEM_DIFICULDADE_ALTA = "Alta";

///Contém uma lista com os nomes das imágens usadas no enunciado.
const DB_FIRESTORE_DOC_ITEM_IMAGENS_ENUNCIADO = "imagens_enunciado";

///Nome da imágem (com extenção) no enunciado ou na alternativa.
const DB_FIRESTORE_DOC_ITEM_IMAGENS_NOME = "nome";

///Largura da imágem (com extenção) no enunciado ou na alternativa.
const DB_FIRESTORE_DOC_ITEM_IMAGENS_LARGURA = "largura";

///Altura da imágem (com extenção) no enunciado ou na alternativa.
const DB_FIRESTORE_DOC_ITEM_IMAGENS_ALTURA = "altura";

///Referência para uma questão já existente.
const DB_FIRESTORE_DOC_ITEM_REFERENCIA = "referencia";

///Usada para indicar as parte do enunciado onde há uma imágem em uma nova linha.
const DB_FIRESTORE_DOC_ITEM_ENUNCIADO_IMAGEM_NOVA_LINHA = "##nl##";

///Usada para indicar as parte do enunciado onde há uma imágem na mesma linha.
const DB_FIRESTORE_DOC_ITEM_ENUNCIADO_IMAGEM_MESMA_LINHA = "##ml##";

///Caminho do diretório de imágens a partir da raiz do Firebase Storage.
const DB_STORAGE_ITENS_IMAGENS = "itens/imagens";

///`key` do campo que contém a largura da imágem no `Map` dos seus metadados.
const DB_STORAGE_IMAGEM_METADATA_WIDTH = "width";

///`key` do campo que contém a altura da imágem no `Map` dos seus metadados.
const DB_STORAGE_IMAGEM_METADATA_HEIGHT = "height";
