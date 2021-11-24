import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../modules/quiz/shared/models/imagem_questao_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';
import '../repositories/questoes/imagem_questao_repository.dart';
import '../repositories/questoes/questoes_repository.dart';
import '../utils/app_assets.dart';
import 'exibir_questao_com_filtro_controller.dart';

part 'exibir_questao_controller.g.dart';

/// Base do controle de páginas ques exibem questões.
/// * Para páginas com a opção de filtrar, veja [ExibirQuestaoComFiltroController].
abstract class ExibirQuestaoController = _ExibirQuestaoControllerBase
    with _$ExibirQuestaoController;

abstract class _ExibirQuestaoControllerBase with Store {
  final ImagemQuestaoRepository _imagemQuestaoRepository;
  final QuestoesRepository _questoesRepository;

  _ExibirQuestaoControllerBase(
    ImagemQuestaoRepository imagemQuestaoRepository,
    QuestoesRepository questoesRepository,
  )   : _imagemQuestaoRepository = imagemQuestaoRepository,
        _questoesRepository = questoesRepository {
    definirIndice(
      questoes.isEmpty ? -1 : 0,
      forcar: true,
    );
    _inicializar();
  }

  Future<void> _inicializar() async {
    await inicializandoRepositorioQuestoes;
    await _carregarImagens();
  }

  /// Quando incompleto indica que o repositório de questões ainda não terminou de fazer a
  /// primeira requisição.
  Future<void> get inicializandoRepositorioQuestoes =>
      _questoesRepository.inicializando;

  /// Índice de [questao] em [questoes].
  /// Será `-1` se [questao] for `null`.
  @readonly
  int _indice = -1;

  /// Questões disponíveis para exibição.
  List<Questao> get questoes;

  /// [Questao] a ser exibida.
  @computed
  Questao? get questao => _indice < 0 ? null : questoes[_indice];

  /// Atribui um novo valor para [_indice].
  /// Se [forcar] for `true`, [valor] será aplicado independentemente do valor atual de [_indice].
  @action
  @protected
  void definirIndice(int valor, {bool forcar = false}) {
    if (_indice != valor || forcar) {
      _indice = valor;
      _carregarImagens();
    }
  }

  /// Retorna um `bool` que define se há uma próxima questão para ser exibida.
  @computed
  bool get podeAvancar => _indice >= 0 && _indice < questoes.length - 1;

  /// Retorna um `bool` que define se há uma questão anterior para ser exibida.
  @computed
  bool get podeVoltar => _indice > 0;

  /// Avança para a próxima questão.
  void avancar() {
    if (podeAvancar) {
      definirIndice(_indice + 1);
    }
  }

  /// Voltar para a questão anterior.
  void voltar() {
    if (podeVoltar) {
      definirIndice(_indice - 1);
      _carregarImagens();
    }
  }

  /// Carregar os [ImageProvider] das imágens de [questao], caso ainda não tenham sido carregados.
  Future<void> _carregarImagens() async {
    if (questao != null) {
      final questao = this.questao!;

      // Carregar imágens do ecunciado.
      if (questao.imagensEnunciado.isNotEmpty) {
        for (var imagem in questao.imagensEnunciado) {
          if (imagem.provider == null) await _definirProvedorImagem(imagem);
        }
      }

      // Carregar imágens das alternativas.
      for (var alternativa in questao.alternativas) {
        if (alternativa.isTipoImagem) {
          final imagem = alternativa.conteudo as ImagemQuestao;
          if (imagem.provider == null) await _definirProvedorImagem(imagem);
        }
      }
    }
  }

  /// Atribui o valor da propriedade [imagem.provider].
  Future<void> _definirProvedorImagem(ImagemQuestao imagem) async {
    if (kIsWeb)
      imagem.provider = MemoryImage(imagem.uint8List, scale: 0.99);
    else {
      final file = await _imagemQuestaoRepository.getImagemFile(imagem);
      imagem.provider = file != null
          ? FileImage(file, scale: 0.99)
          : Image.asset(AppAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
              .image;
    }
  }
}
