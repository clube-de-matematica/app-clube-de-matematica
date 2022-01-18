import '../../utils/strings_db.dart';

abstract class LinTb {
  final Object dataModificacao;
  const LinTb(this.dataModificacao);

  DateTime decodificarDataModificacao();
}

abstract class _LinTbComColunaExcluir extends LinTb {
  final bool excluir;

  _LinTbComColunaExcluir({
    required this.excluir,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbQuestoes extends LinTb {
  final int id;
  final Object enunciado;
  final int gabarito;
  final Object? imagensEnunciado;

  ILinTbQuestoes({
    required this.id,
    required this.enunciado,
    required this.gabarito,
    this.imagensEnunciado,
    required Object dataModificacao,
  }) : super(dataModificacao);

  List<String> decodificarEnunciado();

  List<DataImagem>? decodificarImagensEnunciado();
}

abstract class ILinTbQuestoesCaderno extends LinTb {
  final String id;
  final int ano;
  final int nivel;
  final int indice;
  final int idQuestao;

  ILinTbQuestoesCaderno({
    required this.id,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.idQuestao,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbAssuntos extends LinTb {
  final int id;
  final String assunto;
  final Object? hierarquia;

  ILinTbAssuntos({
    required this.id,
    required this.assunto,
    this.hierarquia,
    required Object dataModificacao,
  }) : super(dataModificacao);

  List<int>? decodificarHierarquia();
}

abstract class ILinTbQuestaoAssunto extends LinTb {
  final int idQuestao;
  final int idAssunto;

  ILinTbQuestaoAssunto({
    required this.idQuestao,
    required this.idAssunto,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbTiposAlternativa extends LinTb {
  final int id;
  final String tipo;

  ILinTbTiposAlternativa({
    required this.id,
    required this.tipo,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbAlternativas extends LinTb {
  final int idQuestao;
  final int sequencial;
  final int idTipo;
  final String conteudo;

  ILinTbAlternativas({
    required this.idQuestao,
    required this.sequencial,
    required this.idTipo,
    required this.conteudo,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbUsuarios extends LinTb {
  final int id;
  final String? email;
  final String? nome;
  final String? foto;
  final bool softDelete;

  ILinTbUsuarios({
    required this.id,
    required this.email,
    required this.nome,
    required this.foto,
    required this.softDelete,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbClubes extends _LinTbComColunaExcluir {
  final int id;
  final String nome;
  final String? descricao;
  final Object dataCriacao;
  final bool privado;
  final String codigo;
  final String? capa;

  ILinTbClubes({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataCriacao,
    required this.privado,
    required this.codigo,
    required this.capa,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  DateTime decodificarDataCriacao();
}

abstract class ILinTbTiposPermissao extends LinTb {
  final int id;
  final String permissao;

  ILinTbTiposPermissao({
    required this.id,
    required this.permissao,
    required Object dataModificacao,
  }) : super(dataModificacao);
}

abstract class ILinTbClubeUsuario extends _LinTbComColunaExcluir {
  final int idClube;
  final int idUsuario;
  final int idPermissao;
  final Object dataAdmissao;
  ILinTbClubeUsuario({
    required this.idClube,
    required this.idUsuario,
    required this.idPermissao,
    required this.dataAdmissao,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  DateTime decodificarDataAdmissao();
}

abstract class ILinTbAtividades extends _LinTbComColunaExcluir {
  final int id;
  final int idClube;
  final String titulo;
  final String? descricao;
  final int idAutor;
  final Object dataCriacao;
  final Object? dataLiberacao;
  final Object? dataEncerramento;
  ILinTbAtividades({
    required this.id,
    required this.idClube,
    required this.titulo,
    required this.descricao,
    required this.idAutor,
    required this.dataCriacao,
    required this.dataLiberacao,
    required this.dataEncerramento,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  DateTime decodificarDataCriacao();
  DateTime? decodificarDataLiberacao();
  DateTime? decodificarDataEncerramento();
}

abstract class ILinTbQuestaoAtividade extends _LinTbComColunaExcluir {
  final int id;
  final String idQuestaoCaderno;
  final int idAtividade;
  ILinTbQuestaoAtividade({
    required this.id,
    required this.idQuestaoCaderno,
    required this.idAtividade,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );
}

abstract class ILinTbRespostaQuestaoAtividade extends _LinTbComColunaExcluir {
  final int idQuestaoAtividade;
  final int idUsuario;
  final int? resposta;
  ILinTbRespostaQuestaoAtividade({
    required this.idQuestaoAtividade,
    required this.idUsuario,
    required this.resposta,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );
}

abstract class ILinTbRespostaQuestao extends _LinTbComColunaExcluir {
  final int idQuestao;
  final int idUsuario;
  final int? resposta;
  ILinTbRespostaQuestao({
    required this.idQuestao,
    required this.idUsuario,
    required this.resposta,
    required bool excluir,
    required Object dataModificacao,
  }) : super(
          excluir: excluir,
          dataModificacao: dataModificacao,
        );
}
