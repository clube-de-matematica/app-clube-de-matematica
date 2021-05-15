import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../filtros/shared/models/filtros_model.dart';
import '../../../filtros/shared/utils/rotas_filtros.dart';
import '../../shared/models/alternativa_item_model.dart';
import '../../shared/models/imagem_item_model.dart';
import '../../shared/models/item_model.dart';
import '../../shared/repositories/imagem_item_repository.dart';
import '../../shared/utils/assets_quiz.dart';
import '../../shared/utils/strings_db_remoto.dart';

part 'quiz_controller.g.dart';

class QuizController = _QuizControllerBase with _$QuizController;

abstract class _QuizControllerBase with Store {
  final ImagemItemRepository imagemItemRepository;
  final Filtros filtros;

  final _initialized = Completer<bool>();

  @observable

  ///Índice da questão selecionada em [itensFiltrados].
  int _indice = 0;

  @observable

  ///Indica qual altenativa está selecionada;
  String? _alternativaSelecionada;

  _QuizControllerBase(this.imagemItemRepository, this.filtros) {
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _carregarImagens();
      _initialized.complete(

          ///Impedir que o futuro seja completado antes de passado um segundo.
          ///Isso é feito para que o indicador de carregamento seja exibido corretamente.
          await Future.delayed(const Duration(seconds: 1), () => true));
    } catch (e) {
      _initialized.completeError(e);
    }
  }

  ///Quando incompleto indica que ainda não há itens para serem exibidos.
  Future<bool> get initialized => _initialized.future;

  @computed

  ///Indica qual altenativa está selecionada;
  String? get alternativaSelecionada => _alternativaSelecionada;

  @computed

  ///Itens selecionado para serem exibidos.
  List<Item> get itensFiltrados => filtros.itensFiltrados;

  @computed

  ///[Item] em exibição.
  Item get item => itensFiltrados[_indice];

  @computed

  ///Retorna o índice da questão selecionada em [itensFiltrados].
  int get indice => _indice;

  @computed

  ///Idica o item exibido e o total de itesn selecionados.
  String get textoContadorBarOpcoesItem =>
      "${indice + 1} de ${itensFiltrados.length}";

  @action

  ///Atribui um novo valor para [_indice].
  ///Se [force] for `true`, [valor] será aplicado independentemente do valor atual de [indice].
  void _setIndice(int valor, {bool force = false}) {
    if (_indice != valor || force) {
      _indice = valor;
      _setAlternativaSelecionada(null);
      _carregarImagens();
    }
  }

  @action

  ///Atribui um novo valor para [_alternativaSelecionada].
  void _setAlternativaSelecionada(String? valor) {
    if (_alternativaSelecionada == valor) {
      _alternativaSelecionada = null;
    } else {
      _alternativaSelecionada = valor;
    }
  }

  ///Será executado quanda [alternativa] for pressionada.
  void onTapAlternativa(Alternativa alternativa) =>
      _setAlternativaSelecionada(alternativa.alternativa);

  @computed

  ///Retorna um `bool` que define se há um próximo item.
  bool get podeAvancar => _indice < itensFiltrados.length - 1;

  @computed

  ///Retorna um `bool` que define se há um item anterior.
  bool get podeVoltar => _indice > 0;

  ///Avança para o próximo item.
  void avancar() {
    if (podeAvancar) {
      _setIndice(_indice + 1);
    }
  }

  ///Voltar para o item anterior.
  void voltar() {
    if (podeVoltar) {
      _setIndice(_indice - 1);
      _carregarImagens();
    }
  }

  @computed

  ///Retorna um `bool` que define se há uma resposta a ser confirmada.
  bool get podeConfirmar => _alternativaSelecionada != null;

  ///Ações a serem executada ao confirmar uma resposta.
  void confirmar() {
    avancar();
  }

  ///Retorna `true` se [string] corresponder ao identificador de imágem em linha.
  bool isImageInLine(String string) =>
      string == DB_FIRESTORE_DOC_ITEM_ENUNCIADO_IMAGEM_MESMA_LINHA;

  ///Retorna `true` se [string] corresponder ao identificador de imágem em nova linha.
  bool isImageNewLine(String string) =>
      string == DB_FIRESTORE_DOC_ITEM_ENUNCIADO_IMAGEM_NOVA_LINHA;

  ///Carregar os [ImageProvider] das imágens do item, caso ainda não tenham sido carregados.
  ///A reação `asyncWhen` é usada para esperar uma condição em um [Observable].
  ///Ficará ativa até que a condição seja satisfeita pela primeira vez.
  ///Após isso ela executa o seu método `dispose`.
  Future<void> _carregarImagens() async {
    ///Aguardar até que a lista de itens não seja vazia.
    await asyncWhen((_) => itensFiltrados.isNotEmpty);

    ///Carregar imágens do ecunciado.
    if (item.imagensEnunciado.isNotEmpty)
      item.imagensEnunciado.forEach((imagem) {
        if (imagem.provider == null) _setImagemProvider(imagem);
      });

    ///Carregar imágens das alternativas.
    item.alternativas.forEach((alternativa) {
      if (alternativa.isTipoImagem) {
        if (alternativa.valorSeImagem!.provider == null)
          _setImagemProvider(alternativa.valorSeImagem!);
      }
    });
  }

  ///Atribui o valor da propriedade [imagem.provider].
  _setImagemProvider(ImagemItem imagem) {
    if (kIsWeb)
      imagemItemRepository.getUrlImagemInDb(imagem.nome).then((url) =>
          imagem.provider = (url != null)
              ? NetworkImage(url, scale: 0.99)
              : Image.asset(QuizAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
                  .image);
    else
      imagemItemRepository.getImagemFile(imagem.nome).then((file) =>
          imagem.provider = file != null
              ? FileImage(file, scale: 0.99)
              : Image.asset(QuizAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
                  .image);
  }

  ///Retorna a opção escolhida pelo usuário dentre as opções disponíveis para o item.
  Future<void> setOpcaoItem(int? opcao) async {
    switch (opcao) {
      case 1:
        await onTapFiltrar();
    }
  }

  ///Ação executada para abrir a página de filtro.
  ///Retornará `true` se o botão "Aplicar" de uma das páginas de filtro for pressionado.
  Future<bool> onTapFiltrar() async {
    ///Usa-se `Modular.to` para caminhos literais e `Modular.link` para rotas no
    ///módulo atual.
    ///Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" de uma das
    ///páginas de  filtro foi pressionado.
    final retorno =
        await Modular.to.pushNamed<bool>(ROTA_PAGINA_FILTROS_TIPOS_PATH) ??
            false;
    if (retorno) _setIndice(0, force: true);
    return retorno;
  }
}
