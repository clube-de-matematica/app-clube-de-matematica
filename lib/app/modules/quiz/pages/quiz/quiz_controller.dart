import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../../../shared/repositories/questoes/imagem_questao_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import '../../../filtros/shared/models/filtros_model.dart';
import '../../shared/models/imagem_questao_model.dart';
import '../../shared/models/opcoesQuestao.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/utils/assets_quiz.dart';

part 'quiz_controller.g.dart';

class QuizController = _QuizControllerBase with _$QuizController;

abstract class _QuizControllerBase with Store {
  final ImagemQuestaoRepository imagemQuestaoRepository;
  final Filtros filtros;

  final _initialized = Completer<bool>();

  /// Índice da questão selecionada em [itensFiltrados].
  @observable
  int _indice = 0;

  /// O sequencial da altenativa selecionada;
  @observable
  int? alternativaSelecionada;

  _QuizControllerBase(this.imagemQuestaoRepository, this.filtros) {
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _carregarImagens();
      _initialized.complete(

          // Impedir que o futuro seja completado antes de passado um segundo.
          // Isso é feito para que o indicador de carregamento seja exibido corretamente.
          await Future.delayed(const Duration(seconds: 1), () => true));
    } catch (e) {
      _initialized.completeError(e);
    }
  }

  /// Quando incompleto indica que ainda não há itens para serem exibidos.
  Future<bool> get initialized => _initialized.future;

  /// Itens selecionado para serem exibidos.
  @computed
  List<Questao> get itensFiltrados => filtros.itensFiltrados;

  /// [Questao] em exibição.
  @computed
  Questao get questao => itensFiltrados[_indice];

  /// Retorna o índice da questão selecionada em [itensFiltrados].
  @computed
  int get indice => _indice;

  /// Idica o item exibido e o total de itesn selecionados.
  @computed
  String get textoContadorBarOpcoesItem =>
      "${indice + 1} de ${itensFiltrados.length}";

  /// Atribui um novo valor para [_indice].
  /// Se [force] for `true`, [valor] será aplicado independentemente do valor atual de [indice].
  @action
  void _setIndice(int valor, {bool force = false}) {
    if (_indice != valor || force) {
      _indice = valor;
      alternativaSelecionada = null;
      _carregarImagens();
    }
  }

  /// Retorna um `bool` que define se há um próximo item.
  @computed
  bool get podeAvancar => _indice < itensFiltrados.length - 1;

  /// Retorna um `bool` que define se há um item anterior.
  @computed
  bool get podeVoltar => _indice > 0;

  /// Avança para o próximo item.
  void avancar() {
    if (podeAvancar) {
      _setIndice(_indice + 1);
    }
  }

  /// Voltar para o item anterior.
  void voltar() {
    if (podeVoltar) {
      _setIndice(_indice - 1);
      _carregarImagens();
    }
  }

  /// Retorna um `bool` que define se há uma resposta a ser confirmada.
  @computed
  bool get podeConfirmar => alternativaSelecionada != null;

  /// Ações a serem executada ao confirmar uma resposta.
  void confirmar() {
    avancar();
  }

  /// Retorna `true` se [string] corresponder ao identificador de imágem em linha.
  bool isImageInLine(String string) =>
      string == DbConst.kDbStringImagemNaoDestacada;

  /// Retorna `true` se [string] corresponder ao identificador de imágem em nova linha.
  bool isImageNewLine(String string) =>
      string == DbConst.kDbStringImagemDestacada;

  /// Carregar os [ImageProvider] das imágens do item, caso ainda não tenham sido carregados.
  /// A reação `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<void> _carregarImagens() async {
    // Aguardar até que a lista de itens não seja vazia.
    await asyncWhen((_) => itensFiltrados.isNotEmpty);

    // Carregar imágens do ecunciado.
    if (questao.imagensEnunciado.isNotEmpty)
      questao.imagensEnunciado.forEach((imagem) {
        if (imagem.provider == null) _setImagemProvider(imagem);
      });

    // Carregar imágens das alternativas.
    questao.alternativas.forEach((alternativa) {
      if (alternativa.isTipoImagem) {
        final imagem = alternativa.conteudo as ImagemQuestao;
        if (imagem.provider == null) _setImagemProvider(imagem);
      }
    });
  }

  /// Atribui o valor da propriedade [imagem.provider].
  _setImagemProvider(ImagemQuestao imagem) {
    if (kIsWeb)
      imagem.provider = MemoryImage(imagem.uint8List, scale: 0.99);
    else
      imagemQuestaoRepository.getImagemFile(imagem).then((file) =>
          imagem.provider = file != null
              ? FileImage(file, scale: 0.99)
              : Image.asset(QuizAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
                  .image);
  }

  /// Retorna a opção escolhida pelo usuário dentre as opções disponíveis para o item.
  Future<void> setOpcaoItem(BuildContext context, OpcoesQuestao opcao) async {
    switch (opcao) {
      case OpcoesQuestao.none:
      case OpcoesQuestao.filter:
        await onTapFiltrar(context);
    }
  }

  /// Ação executada para abrir a página de filtro.
  /// Retornará `true` se o botão "Aplicar" de uma das páginas de filtro for pressionado.
  Future<bool> onTapFiltrar(BuildContext context) async {
    // Usa-se `Modular.to` para caminhos literais e `Modular.link` para rotas no
    // módulo atual.
    // Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" de uma das
    // páginas de  filtro foi pressionado.
    /* final retorno = await Modular.to
            .pushNamed<bool>(FiltrosModule.kAbsoluteRouteFiltroTiposPage) ??
        false; */
    final retorno =
        await Navigation.showPage<bool>(context, RoutePage.filtrosTipos) ??
            false;
    if (retorno) _setIndice(0, force: true);
    return retorno;
  }
}
