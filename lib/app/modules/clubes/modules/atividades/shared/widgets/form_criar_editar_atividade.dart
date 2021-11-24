import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/appInputDatePickerFormField.dart';
import '../../../../../../shared/widgets/app_text_form_field.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../models/atividade.dart';
import '../../pages/selecionar_questoes/selecionar_questoes_page.dart';

typedef ValorSelecionarQuestoesFormField = List<Questao>;

/// Formulário para a criação ou edição de uma atividade.
class FormCriarEditarAtividade extends StatefulWidget {
  const FormCriarEditarAtividade({
    Key? key,
    this.titulo,
    this.descricao,
    this.liberacao,
    this.encerramento,
    this.questoes,
    this.validarTitulo,
    this.salvar,
  }) : super(key: key);

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
  bool carregando = false;
  late String titulo;
  String? descricao;
  late DateTime liberacao;
  DateTime? encerramento;
  late List<Questao> questoes;

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

  void _salvar(BuildContext context) async {
    if (!carregando) {
      final form = Form.of(context);
      if (form?.validate() ?? false) {
        setState(() => carregando = true);
        form?.save();
        await widget.salvar?.call(
          descricao: descricao,
          encerramento: encerramento,
          liberacao: liberacao,
          titulo: titulo,
          questoes: questoes,
        );
        if (mounted) setState(() => carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onWillPop: () async {
        final sair = await BottomSheetCancelarSair(
          message: 'Há dados não salvos que serão descartados',
        ).showModal<bool>(context);
        return sair ?? false;
      },
      child: Builder(builder: (context) {
        final sizedBox = () => const SizedBox(height: 8.0);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            //backgroundColor: ,
            child: Icon(
              Icons.check,
              //color: ,
              size: 28.0,
            ),
            onPressed: () => _salvar(context),
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
    Key? key,
    String? initialValue,
    TextInputAction? textInputAction = TextInputAction.next,
    FocusNode? focusNode,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) : super(
          key: key,
          initialValue: initialValue,
          textInputAction: textInputAction,
          focusNode: focusNode,
          maxLength: 50,
          labelText: 'Título',
          hintText: 'Título da atividade',
          onSaved: onSaved,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
        );
}

/// Um [TextFormField] para inserir a descrição da atividade.
class DescricaoAtividadeTextFormField extends AppTextFormField {
  DescricaoAtividadeTextFormField({
    Key? key,
    String? initialValue,
    TextInputAction? textInputAction = TextInputAction.next,
    FocusNode? focusNode,
    void Function(String?)? onSaved,
    void Function(String)? onFieldSubmitted,
  }) : super(
          key: key,
          initialValue: initialValue,
          textInputAction: textInputAction,
          focusNode: focusNode,
          maxLength: 200,
          maxLines: 5,
          labelText: 'Descrição',
          hintText: 'Descrição da atividade',
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
        );
}

/// Um [TextFormField] para inserir a data de liberação da atividade.
class DataLiberacaoAtividadeTextFormField extends AppInputDatePickerFormField {
  DataLiberacaoAtividadeTextFormField({
    Key? key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    void Function(DateTime?)? onSaved,
    void Function(DateTime?)? onFieldSubmitted,
    bool Function(DateTime)? selectableDayPredicate,
  }) : super(
          key: key,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate:
              lastDate ?? DateTime((firstDate ?? DateTime.now()).year + 1),
          textInputAction: textInputAction,
          fieldLabelText: 'Data de liberação',
          errorInvalidText: 'Fora do intervalo',
          focusNode: focusNode,
          onDateSaved: onSaved,
          onDateSubmitted: onFieldSubmitted,
          selectableDayPredicate: selectableDayPredicate,
        );
}

/// Um [TextFormField] para inserir a data de encerramento da atividade.
class DataEncerramentoAtividadeTextFormField
    extends AppInputDatePickerFormField {
  DataEncerramentoAtividadeTextFormField({
    Key? key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    void Function(DateTime?)? onSaved,
    void Function(DateTime?)? onFieldSubmitted,
    bool Function(DateTime)? selectableDayPredicate,
  }) : super(
          key: key,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate:
              lastDate ?? DateTime((firstDate ?? DateTime.now()).year + 1),
          textInputAction: textInputAction,
          fieldLabelText: 'Data de encerramento',
          errorInvalidText: 'Fora do intervalo',
          focusNode: focusNode,
          nullable: true,
          onDateSaved: onSaved,
          onDateSubmitted: onFieldSubmitted,
          selectableDayPredicate: selectableDayPredicate,
        );
}

/// Um [FormField] para selecionar as questões da atividade.
class SelecionarQuestoesFormField
    extends FormField<ValorSelecionarQuestoesFormField> {
  SelecionarQuestoesFormField({
    Key? key,
    ValorSelecionarQuestoesFormField? questoes,
    FocusNode? focusNode,
    void Function(ValorSelecionarQuestoesFormField?)? onSaved,
  }) : super(
          key: key,
          onSaved: onSaved,
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
                    icon: Icon(Icons.chevron_right),
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
