import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/appInputDatePickerFormField.dart';
import '../../../../../../shared/widgets/app_text_form_field.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/utils/tema_clube.dart';
import '../../pages/selecionar_questoes/selecionar_questoes_page.dart';

typedef ValorSelecionarQuestoesFormField = List<Questao>;

/// Formulário para a criação ou edição de uma atividade.
class FormCriarEditarAtividade extends StatefulWidget {
  const FormCriarEditarAtividade({
    super.key,
    this.titulo,
    this.descricao,
    this.liberacao,
    this.encerramento,
    this.questoes,
    this.validarTitulo,
    this.salvar,
  });

  final String? titulo;
  final String? descricao;
  final DateTime? liberacao;
  final DateTime? encerramento;
  final List<Questao>? questoes;

  /// Deve retornar uma string de erro quando o valor recebido no parâmetro for inválido,
  /// ou, caso contrário, `null`.
  final String? Function(String?)? validarTitulo;

  /// Ação executada ao precionar o botão de confirmação.
  final FutureOr<void> Function({
    required String titulo,
    required String? descricao,
    required DateTime liberacao,
    required DateTime? encerramento,
    required List<Questao> questoes,
  })? salvar;

  @override
  State<FormCriarEditarAtividade> createState() =>
      _FormCriarEditarAtividadeState();
}

class _FormCriarEditarAtividadeState extends State<FormCriarEditarAtividade> {
  final focoNome = FocusNode();
  final focoDescricao = FocusNode();
  final focoLiberacao = FocusNode();
  final focoEncerramento = FocusNode();
  bool _salvando = false;
  late String titulo;
  String? descricao;
  late DateTime liberacao;
  DateTime? encerramento;
  late List<Questao> questoes;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _podeFechar = true;

  @override
  void initState() {
    super.initState();
    titulo = widget.titulo ?? '';
    descricao = widget.descricao;
    liberacao = widget.liberacao ?? DateUtils.dateOnly(DateTime.now());
    encerramento = widget.encerramento;
    questoes = widget.questoes ?? [];
  }

  @override
  void dispose() {
    focoNome.dispose();
    focoDescricao.dispose();
    focoLiberacao.dispose();
    focoEncerramento.dispose();
    super.dispose();
  }

  FutureOr<void> _salvar() async {
    if (!_salvando) {
      //final form = Form.of(contexto);
      final form = formKey.currentState;
      if (form?.validate() ?? false) {
        setState(() {
          _salvando = true;
        });
        form?.save();
        setState(() {
          _podeFechar = true; //Deve ocorrer antes da chamada de widget.salvar
        });
        await widget.salvar?.call(
          descricao: descricao,
          encerramento: encerramento,
          liberacao: liberacao,
          titulo: titulo,
          questoes: questoes,
        );
        if (mounted) {
          setState(() {
            _salvando = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void onPopInvokedWithResult(canPop, result) async {
      if (!canPop) {
        final retorno = await BottomSheetSalvarSairCancelar(
          title: const Text('Pode haver dados não salvos'),
          message: 'Ao sair os dados não salvos serão descartados.',
        ).showModal<int>(context);
        if (retorno == 2) {
          await _salvar();
        } else {
          if (mounted) {
            setState(() {
              _podeFechar = retorno == 1;
            });
          }
          if (_podeFechar) {
            if (context.mounted) {
              Navigator.of(context).pop(result);
            }
          }
        }
      }
    }

    void onChanged() {
      if (_podeFechar) {
        if (mounted) {
          setState(() {
            _podeFechar = false;
          });
        }
      }
    }

    return Form(
      key: formKey,
      canPop: _podeFechar,
      onPopInvokedWithResult: onPopInvokedWithResult,
      onChanged: onChanged,
      child: Builder(builder: (context) {
        final tema = Modular.get<TemaClube>();
        sizedBox() => const SizedBox(height: 8.0);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: tema.primaria,
            child: Icon(
              Icons.done,
              color: tema.sobrePrimaria,
            ),
            onPressed: () => _salvar(),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TituloAtividadeTextFormField(
                initialValue: titulo,
                focusNode: focoNome,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focoDescricao);
                },
                onSaved: (valor) {
                  if (valor != null) titulo = valor.trim();
                },
                validator: widget.validarTitulo,
              ),
              sizedBox(),
              DescricaoAtividadeTextFormField(
                initialValue: descricao,
                focusNode: focoDescricao,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focoLiberacao);
                },
                onSaved: (valor) => descricao = valor?.trim(),
              ),
              sizedBox(),
              Builder(builder: (context) {
                final liberacaoTemp = ValueNotifier(liberacao);
                return Column(
                  children: [
                    DataLiberacaoAtividadeTextFormField(
                      initialDate: liberacao,
                      focusNode: focoLiberacao,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(focoEncerramento);
                      },
                      onSaved: (valor) {
                        if (valor != null) liberacao = valor;
                      },
                      // Capiturar o valor que está sendo atualizado.
                      selectableDayPredicate: (novaData) {
                        liberacaoTemp.value = novaData;
                        return true;
                      },
                    ),
                    const SizedBox(height: 30.0),
                    ValueListenableBuilder(
                      valueListenable: liberacaoTemp,
                      builder: (context, DateTime data, _) {
                        final encerramento =
                            (this.encerramento?.isAfter(data) ?? true)
                                ? this.encerramento
                                : data;
                        return DataEncerramentoAtividadeTextFormField(
                          firstDate: data,
                          initialDate: encerramento,
                          focusNode: focoEncerramento,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          onSaved: (valor) => this.encerramento = valor,
                        );
                      },
                    ),
                  ],
                );
              }),
              const SizedBox(height: 30.0),
              SelecionarQuestoesFormField(
                questoes: questoes,
                onSaved: (valor) => questoes = valor ?? [],
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Um [TextFormField] para inserir o título da atividade.
class TituloAtividadeTextFormField extends AppTextFormField {
  TituloAtividadeTextFormField({
    super.key,
    super.initialValue,
    super.textInputAction = TextInputAction.next,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.onFieldSubmitted,
  }) : super(
          maxLength: 50,
          labelText: 'Título',
          hintText: 'Título da atividade',
        );
}

/// Um [TextFormField] para inserir a descrição da atividade.
class DescricaoAtividadeTextFormField extends AppTextFormField {
  DescricaoAtividadeTextFormField({
    super.key,
    super.initialValue,
    super.textInputAction = TextInputAction.next,
    super.focusNode,
    super.onSaved,
    super.onFieldSubmitted,
  }) : super(
          maxLength: 200,
          maxLines: 5,
          labelText: 'Descrição',
          hintText: 'Descrição da atividade',
        );
}

DateTime _efetivoLimiteInferior({
  required DateTime? limiteInferior,
  required DateTime? dataInicial,
}) {
  limiteInferior ??= DateTime.now();
  if (dataInicial != null) {
    if (dataInicial.isBefore(limiteInferior)) return dataInicial;
  }
  return limiteInferior;
}

DateTime _efetivoLimiteSuperior({
  required DateTime? limiteInferior,
  required DateTime? dataInicial,
  required DateTime? limiteSuperior,
}) {
  final efetivoLimiteInferior = _efetivoLimiteInferior(
    limiteInferior: limiteInferior,
    dataInicial: dataInicial,
  );
  limiteSuperior ??= efetivoLimiteInferior.add(const Duration(days: 364));
  if (dataInicial != null) {
    if (dataInicial.isAfter(limiteSuperior)) {
      return dataInicial.add(const Duration(days: 364));
    }
  }
  return limiteSuperior;
}

/// Um [TextFormField] para inserir a data de liberação da atividade.
class DataLiberacaoAtividadeTextFormField extends AppInputDatePickerFormField {
  DataLiberacaoAtividadeTextFormField({
    super.key,
    super.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    super.textInputAction,
    super.focusNode,
    void Function(DateTime?)? onSaved,
    void Function(DateTime?)? onFieldSubmitted,
    super.selectableDayPredicate,
  }) : super(
          firstDate: _efetivoLimiteInferior(
            limiteInferior: firstDate,
            dataInicial: initialDate,
          ),
          lastDate: _efetivoLimiteSuperior(
            limiteInferior: firstDate,
            dataInicial: initialDate,
            limiteSuperior: lastDate,
          ),
          fieldLabelText: 'Data de liberação',
          errorInvalidText: 'Fora do intervalo',
          onDateSaved: onSaved,
          onDateSubmitted: onFieldSubmitted,
        );
}

/// Um [TextFormField] para inserir a data de encerramento da atividade.
class DataEncerramentoAtividadeTextFormField
    extends AppInputDatePickerFormField {
  DataEncerramentoAtividadeTextFormField({
    super.key,
    super.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    super.textInputAction,
    super.focusNode,
    void Function(DateTime?)? onSaved,
    void Function(DateTime?)? onFieldSubmitted,
    super.selectableDayPredicate,
  }) : super(
          firstDate: _efetivoLimiteInferior(
            limiteInferior: firstDate,
            dataInicial: initialDate,
          ),
          lastDate: _efetivoLimiteSuperior(
            limiteInferior: firstDate,
            dataInicial: initialDate,
            limiteSuperior: lastDate,
          ),
          fieldLabelText: 'Data de encerramento',
          errorInvalidText: 'Fora do intervalo',
          nullable: true,
          onDateSaved: onSaved,
          onDateSubmitted: onFieldSubmitted,
        );
}

/// Um [FormField] para selecionar as questões da atividade.
class SelecionarQuestoesFormField
    extends FormField<ValorSelecionarQuestoesFormField> {
  SelecionarQuestoesFormField({
    super.key,
    ValorSelecionarQuestoesFormField? questoes,
    FocusNode? focusNode,
    super.onSaved,
  }) : super(
          initialValue: questoes,
          builder: (field) {
            return Builder(builder: (context) {
              final InputDecorationTheme inputTheme =
                  Theme.of(context).inputDecorationTheme;
              final numQuestoes = field.value?.length ?? 0;
              return InputDecorator(
                decoration: InputDecoration(
                  border: inputTheme.border ?? const UnderlineInputBorder(),
                  filled: inputTheme.filled,
                  labelText: 'Questões',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      // Se retornar `null`, a página foi fechada sem confimar a seleção.
                      final questoesSelecionadas = await Navigator.of(context)
                          .push<List<Questao>>(MaterialPageRoute(
                              builder: (_) => SelecionarQuestoesPage(
                                  questoes: field.value)));
                      if (questoesSelecionadas != null) {
                        field.didChange(questoesSelecionadas);
                      }
                    },
                  ),
                ),
                isFocused: focusNode?.hasFocus ?? false,
                isEmpty: false,
                child: InkWell(
                  child: Text(
                    numQuestoes == 0
                        ? 'Nenhuma selecionada'
                        : '$numQuestoes ${numQuestoes == 1 ? 'selecionada' : 'selecionadas'}',
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    // Se retornar `null`, a página foi fechada sem confimar a seleção.
                    final questoesSelecionadas = await Navigator.of(context)
                        .push<List<Questao>>(MaterialPageRoute(
                            builder: (_) =>
                                SelecionarQuestoesPage(questoes: field.value)));
                    if (questoesSelecionadas != null) {
                      field.didChange(questoesSelecionadas);
                    }
                  },
                ),
              );
            });
          },
        );
}
