import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

import '../../services/db_servicos_interface.dart';
import '../../shared/utils/strings_db.dart';
import '../quiz/shared/models/alternativa_questao_model.dart';
import '../quiz/shared/models/imagem_questao_model.dart';
import '../quiz/shared/models/questao_model.dart';
import 'assuntos/selecionar_assuntos_controller.dart';

part 'inserir_questao_controller.g.dart';

class InserirQuestaoController = InserirQuestaoControllerBase
    with _$InserirQuestaoController;

abstract class InserirQuestaoControllerBase with Store {
  int? ano;
  @observable
  int? nivel;
  int? indice;
  final assuntos = ObservableSet<ArvoreAssuntos>();
  final List<String> enunciado = [];
  final List<DataAlternativa> alternativas = [0, 1, 2, 3, 4]
      .map((sequencial) => <String, dynamic>{
            DbConst.kDbDataAlternativaKeyIdQuestao: -1,
            DbConst.kDbDataAlternativaKeySequencial: sequencial,
          })
      .toList();
  @observable
  int? gabarito;
  final List<ImagemQuestao> imagensEnunciado = [];
  @observable
  bool referencia = false;
  @observable
  int? nivelReferencia;
  int? indiceReferencia;
  final int _compressao = 100; //TODO

  IDbServicos get _dbServicos => Modular.get<IDbServicos>();

  Future<Questao?> inserirQuestao(Questao questao) async {
    return referencia
        ? _inserirReferenciaQuestao(questao)
        : _inserirQuestao(questao);
  }

  Future<Questao?> _inserirQuestao(Questao questao) async {
    final sucesso = await _dbServicos.inserirQuestao(questao);
    if (sucesso) {
      limpar();
      return _dbServicos.obterQuestao(questao.idAlfanumerico);
    }
    return null;
  }

  Future<Questao?> _inserirReferenciaQuestao(Questao questao) async {
    final ref = await _questaoReferencia();
    if (ref == null) return null;
    final sucesso = await _dbServicos.inserirReferenciaQuestao(questao, ref.id);
    if (sucesso) {
      limpar();
      return _dbServicos.obterQuestao(questao.idAlfanumerico);
    }
    return null;
  }

  Future<Questao?> _questaoReferencia() async {
    if (!referencia) return null;
    indice() {
      final texto = indiceReferencia.toString();
      return texto.length == 1 ? '0$texto' : texto;
    }

    final lista = await _dbServicos.obterQuestoes(
      ids: ['${ano}PF1N${nivelReferencia}Q${indice()}'],
      limit: 1,
    );
    return lista.isEmpty ? null : lista.single;
  }

  Future<Questao?> questao() async {
    idAlfanumerico() {
      var idParts = [
        '${ano!}', //Ano
        'PF1', //Fase
        'N${nivel!}', //Nível
        'Q${() {
          final texto = indice.toString();
          return texto.length == 1 ? '0$texto' : texto;
        }()}', // Questão
      ];
      return idParts.join("");
    }

    final ref = await _questaoReferencia();

    try {
      return Questao.noSingleton(
        id: -1,
        idAlfanumerico: idAlfanumerico(),
        ano: ano!,
        nivel: nivel!,
        indice: indice!,
        assuntos: referencia
            ? ref!.assuntos
            : assuntos.map((e) => e.assunto).toList(),
        enunciado: referencia ? ref!.enunciado : enunciado,
        alternativas: referencia
            ? ref!.alternativas
            : alternativas.map((e) => Alternativa.fromJson(e)).toList(),
        gabarito: referencia ? ref!.gabarito : gabarito!,
        imagensEnunciado: referencia ? ref!.imagensEnunciado : imagensEnunciado,
      );
    } catch (_) {
      return null;
    }
  }

  Future<ImagemQuestao?> getImagemEnunciado(bool destacada) async {
    final dados = await _getDataImagem();
    if (dados.isEmpty) return null;

    dados[ImagemQuestao.kKeyName] =
        'imagem_enunciado_${imagensEnunciado.length}.temp';

    final imagemModelo = ImagemQuestao.fromMap(dados);
    imagensEnunciado.add(imagemModelo);
    destacada
        ? enunciado.add(DbConst.kDbStringImagemDestacada)
        : enunciado.add(DbConst.kDbStringImagemNaoDestacada);

    return imagemModelo;
  }

  Future<ImagemQuestao?> getImagemAlternativa(int sequencial) async {
    const keyConteudo = DbConst.kDbDataAlternativaKeyConteudo;
    /* final conteudo = alternativas[sequencial][keyConteudo] as String?;
    if (conteudo != null) {
      final dados = jsonDecode(conteudo) as Map;
      dados[ImagemQuestao.kKeyName] = 'imagem_alternativa_$sequencial.temp';
      return ImagemQuestao.fromMap(dados.cast());
    } */
    final dados = await _getDataImagem();
    if (dados.isEmpty) return null;
    alternativas[sequencial][keyConteudo] = jsonEncode(dados);
    dados[ImagemQuestao.kKeyName] = 'imagem_alternativa_$sequencial.temp';
    return ImagemQuestao.fromMap(dados);
  }

  Future<DataImagem> _getDataImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: _compressao,
    );
    if (pickedFile == null) return DataImagem();
    //print('------------------- ${(await File(pickedFile.path).readAsBytes()).lengthInBytes / 1024}');

    final arquivoEditado =
        pickedFile; //await _editarImagem(File(pickedFile.path)) ?? File(pickedFile.path);

    final bytes = await arquivoEditado.readAsBytes();
    //print('------------------- ${bytes.lengthInBytes / 1024}');

    final completador = Completer<ui.Image>();
    MemoryImage(bytes).resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        if (!completador.isCompleted) completador.complete(info.image);
      }),
    );

    final imagem = await completador.future;
    final DataImagem dados = {
      DbConst.kDbDataImagemKeyBase64: base64Encode(bytes),
      DbConst.kDbDataImagemKeyLargura: imagem.width,
      DbConst.kDbDataImagemKeyAltura: imagem.height,
    };
    return dados;
  }

/* 
  Future<File?> _editarImagem(File arquivo) async {
    if (kIsWeb) return null;
    File? arquivoCortado = await ImageCropper().cropImage(
      sourcePath: arquivo.path,
      compressQuality: _compressao,
      compressFormat: ImageCompressFormat.png,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        if (Platform.isIOS) ...[
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
        ],
        CropAspectRatioPreset.ratio16x9,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar',
        toolbarColor: AppTheme.instance.temaClaro.colorScheme.primary,
        toolbarWidgetColor: AppTheme.instance.temaClaro.colorScheme.onPrimary,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Editar',
      ),
    );
    return arquivoCortado;
  }
*/

  @action
  void limpar() {
    ano = null;
    nivel = null;
    indice = null;
    assuntos.clear();
    enunciado.clear();
    for (var element in alternativas) {
      element.remove(DbConst.kDbDataAlternativaKeyConteudo);
      element.remove(DbConst.kDbDataAlternativaKeyTipo);
    }
    gabarito = null;
    imagensEnunciado.clear();
    referencia = false;
    nivelReferencia = null;
    indiceReferencia = null;
  }
}
