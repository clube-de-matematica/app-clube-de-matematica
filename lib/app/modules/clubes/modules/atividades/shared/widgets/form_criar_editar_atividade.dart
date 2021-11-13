import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/appInputDatePickerFormField.dart';
import '../../../../../../shared/widgets/app_text_form_field.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
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
    this.onCriar,
  }) : super(key: key);

  final String? titulo;
  final String? descricao;
  final DateTime? liberacao;
  final DateTime? encerramento;
  final ValorSelecionarQuestoesFormField? questoes;

  /// Deve retornar uma string de erro quando o valor recebido no parâmetro for inválido,
  /// ou, caso contrário, `null`.
  final String? Function(String?)? validarTitulo;

  /// Ação executada ao precionar o botão de confirmação.
  final Future Function({
    required String titulo,
    String? descricao,
    required DateTime liberacao,
    DateTime? encerramento,
  })? onCriar;

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
  ValorSelecionarQuestoesFormField? questoes;

  @override
  void initState() {
    super.initState();
    if (widget.titulo != null) titulo = widget.titulo!;
    descricao = widget.descricao;
    if (widget.liberacao != null) liberacao = widget.liberacao!;
    encerramento = widget.encerramento;
    questoes = widget.questoes;
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
        await widget.onCriar?.call(
          descricao: descricao,
          encerramento: encerramento,
          liberacao: liberacao,
          titulo: titulo,
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
                focusNode: focoDescricao,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focoLiberacao);
                },
                onSaved: (valor) => descricao = valor?.trim(),
              ),
              sizedBox(),
              DataLiberacaoAtividadeTextFormField(
                focusNode: focoLiberacao,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focoEncerramento);
                },
                onSaved: (valor) {
                  if (valor != null) liberacao = valor;
                },
              ),
              const SizedBox(height: 30.0),
              DataEncerramentoAtividadeTextFormField(
                focusNode: focoEncerramento,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                onSaved: (valor) => encerramento = valor,
              ),
              const SizedBox(height: 30.0),
              SelecionarQuestoesFormField(
                questoes: questoes,
                onSaved: (valor) => questoes = valor,
              ),
/* 
              ListTile(
                title: const Text('Questões'),
                visualDensity: VisualDensity.compact,
                trailing: Icon(Icons.chevron_right),
                shape: Theme.of(context).inputDecorationTheme.border?.copyWith(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          SelecionarQuestoesPage(questoes: questoes)));
                },
              ),
               */
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
        );
}

/// Um [FormField] para selecionar as questões da atividade.
class SelecionarQuestoesFormField
    extends FormField<ValorSelecionarQuestoesFormField> {
  SelecionarQuestoesFormField({
    Key? key,
    ValorSelecionarQuestoesFormField? questoes,
    void Function(ValorSelecionarQuestoesFormField?)? onSaved,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: questoes,
          builder: (field) {
            return Builder(builder: (context) {
              final numQuestoes = field.value?.length ?? 0;
              return ListTile(
                title: Text(numQuestoes == 0
                    ? 'Nenhuma questão selecionada'
                    : '$numQuestoes selecionada(s)'),
                visualDensity: VisualDensity.compact,
                trailing: Icon(Icons.chevron_right),
                shape: Theme.of(context).inputDecorationTheme.border?.copyWith(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final questoesSelecionadas = await Navigator.of(context)
                      .push<ValorSelecionarQuestoesFormField>(MaterialPageRoute(
                          builder: (_) =>
                              SelecionarQuestoesPage(questoes: field.value)));
                  field.didChange(questoesSelecionadas);
                },
              );
            });
          },
        );
}
