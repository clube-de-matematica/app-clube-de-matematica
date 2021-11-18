import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../navigation.dart';
import '../repositories/questoes/imagem_questao_repository.dart';
import '../utils/app_assets.dart';
import '../../modules/filtros/shared/models/filtros_model.dart';
import '../../modules/quiz/shared/models/imagem_questao_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';

part 'exibir_questao_controller.g.dart';

class ExibirQuestaoController = _ExibirQuestaoControllerBase
    with _$ExibirQuestaoController;

abstract class _ExibirQuestaoControllerBase with Store implements Disposable {
  final ImagemQuestaoRepository _imagemQuestaoRepository;
  final Filtros filtros;
  final _disposers = <ReactionDisposer>[];

  _ExibirQuestaoControllerBase({
    required ImagemQuestaoRepository imagemQuestaoRepository,
    required this.filtros,
  }) : _imagemQuestaoRepository = imagemQuestaoRepository {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _disposers.add(
      autorun((_) {
        _definirIndice(
          questoesFiltradas.isEmpty ? -1 : 0,
          forcar: true,
        );
      }),
    );
    await inicializandoRepositorioQuestoes;
    await _carregarImagens();
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }

  /// Quando incompleto indica que o repositório de questões ainda não terminou de fazer a
  /// primeira requisição.
  Future<void> get inicializandoRepositorioQuestoes =>
      filtros.questoesRepository.inicializando;

  /// Índice de [questao] em [questoesFiltradas].
  /// Será `-1` se [questao] for `null`.
  @readonly
  int _indice = -1;

  /// Questões disponíveis para exibição.
  @computed
  List<Questao> get questoesFiltradas => filtros.itensFiltrados;

  /// [Questao] a ser exibida.
  @computed
  Questao? get questao => _indice < 0 ? null : questoesFiltradas[_indice];

  /// Atribui um novo valor para [_indice].
  /// Se [forcar] for `true`, [valor] será aplicado independentemente do valor atual de [_indice].
  @action
  void _definirIndice(int valor, {bool forcar = false}) {
    if (_indice != valor || forcar) {
      _indice = valor;
      _carregarImagens();
    }
  }

  /// Retorna um `bool` que define se há uma próxima questão para ser exibida.
  @computed
  bool get podeAvancar =>
      _indice >= 0 && _indice < questoesFiltradas.length - 1;

  /// Retorna um `bool` que define se há uma questão anterior para ser exibida.
  @computed
  bool get podeVoltar => _indice > 0;

  /// Avança para a próxima questão.
  void avancar() {
    if (podeAvancar) {
      _definirIndice(_indice + 1);
    }
  }

  /// Voltar para a questão anterior.
  void voltar() {
    if (podeVoltar) {
      _definirIndice(_indice - 1);
      _carregarImagens();
    }
  }

  /// Carregar os [ImageProvider] das imágens de [questao], caso ainda não tenham sido carregados.
  Future<void> _carregarImagens() async {
    if (questao != null) {
      final questao = this.questao!;

      // Carregar imágens do ecunciado.
      if (questao.imagensEnunciado.isNotEmpty)
        questao.imagensEnunciado.forEach((imagem) {
          if (imagem.provider == null) _definirProvedorImagem(imagem);
        });

      // Carregar imágens das alternativas.
      questao.alternativas.forEach((alternativa) {
        if (alternativa.isTipoImagem) {
          final imagem = alternativa.conteudo as ImagemQuestao;
          if (imagem.provider == null) _definirProvedorImagem(imagem);
        }
      });
    }
  }

  /// Atribui o valor da propriedade [imagem.provider].
  _definirProvedorImagem(ImagemQuestao imagem) {
    if (kIsWeb)
      imagem.provider = MemoryImage(imagem.uint8List, scale: 0.99);
    else
      _imagemQuestaoRepository.getImagemFile(imagem).then((file) =>
          imagem.provider = file != null
              ? FileImage(file, scale: 0.99)
              : Image.asset(AppAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
                  .image);
  }

  /// Ação executada para abrir a página de filtro.
  /// Retornará o objeto [Filtros] resultante.
  Future<Filtros> abrirPaginaFiltros(BuildContext context) async {
    // Usa-se `Modular.to` para caminhos literais e `Modular.link` para rotas no
    // módulo atual.
    // Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" de uma das
    // páginas de  filtro foi pressionado.
    /* final retorno = await Modular.to
            .pushNamed<bool>(FiltrosModule.kAbsoluteRouteFiltroTiposPage) ??
        false; */
    final Filtros? retorno = await Navegacao.abrirPagina<Filtros>(
      context,
      RotaPagina.filtrosTipos,
      argumentos: filtros,
    );
    /* // Substituído pela Reaction criada no método de inicialização.
    if (retorno) {
      _setIndice(
        filtros.itensFiltrados.isEmpty ? null : 0,
        force: true,
      );
    } */
    return retorno ?? filtros;
  }

  /// Limpa os filtros selecionados.
  void limparFiltros() => filtros.limpar();
}
