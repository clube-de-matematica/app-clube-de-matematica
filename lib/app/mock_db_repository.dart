import 'package:clubedematematica/app/shared/repositories/interface_db_repository.dart';
import 'package:clubedematematica/app/shared/utils/strings_db.dart';
import 'package:mockito/mockito.dart';

/// Mock para a classe [AuthFirebaseRepository].
class MockDbRepository extends Fake implements IRemoteDbRepository {
  @override
  Future<DataCollection> getAssuntos() async {
    return [
      {
        DbConst.kDbDataAssuntoKeyId: 1,
        DbConst.kDbDataAssuntoKeyTitulo: 'Geometria',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 2,
        DbConst.kDbDataAssuntoKeyTitulo: 'Área',
        DbConst.kDbDataAssuntoKeyHierarquia: [1],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 3,
        DbConst.kDbDataAssuntoKeyTitulo: 'Área de polígonos',
        DbConst.kDbDataAssuntoKeyHierarquia: [1, 2],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 4,
        DbConst.kDbDataAssuntoKeyTitulo: 'Área do triângulo',
        DbConst.kDbDataAssuntoKeyHierarquia: [1, 2, 3],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 5,
        DbConst.kDbDataAssuntoKeyTitulo: 'Aritmética',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 6,
        DbConst.kDbDataAssuntoKeyTitulo: 'Expressões numéricas',
        DbConst.kDbDataAssuntoKeyHierarquia: [5],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 8,
        DbConst.kDbDataAssuntoKeyTitulo: 'Fatoração',
        DbConst.kDbDataAssuntoKeyHierarquia: [5],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 9,
        DbConst.kDbDataAssuntoKeyTitulo: 'Decomposição em fatores primos',
        DbConst.kDbDataAssuntoKeyHierarquia: [5, 8],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 10,
        DbConst.kDbDataAssuntoKeyTitulo: 'Álgebra',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 11,
        DbConst.kDbDataAssuntoKeyTitulo: 'Equações algébricas',
        DbConst.kDbDataAssuntoKeyHierarquia: [10],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 15,
        DbConst.kDbDataAssuntoKeyTitulo: 'Sequências',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 16,
        DbConst.kDbDataAssuntoKeyTitulo: 'Progressão Aritmética',
        DbConst.kDbDataAssuntoKeyHierarquia: [15],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 17,
        DbConst.kDbDataAssuntoKeyTitulo: 'Soma dos termos de uma PA',
        DbConst.kDbDataAssuntoKeyHierarquia: [15, 16],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 19,
        DbConst.kDbDataAssuntoKeyTitulo: 'Mínimo múltiplo comum',
        DbConst.kDbDataAssuntoKeyHierarquia: [5],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 20,
        DbConst.kDbDataAssuntoKeyTitulo: 'Matemática financeira',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 21,
        DbConst.kDbDataAssuntoKeyTitulo: 'Porcentagem',
        DbConst.kDbDataAssuntoKeyHierarquia: [20],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 23,
        DbConst.kDbDataAssuntoKeyTitulo: 'Divisibilidade',
        DbConst.kDbDataAssuntoKeyHierarquia: [5],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 26,
        DbConst.kDbDataAssuntoKeyTitulo: 'Termo geral de uma PA',
        DbConst.kDbDataAssuntoKeyHierarquia: [15, 16],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 30,
        DbConst.kDbDataAssuntoKeyTitulo: 'Área do quadrado',
        DbConst.kDbDataAssuntoKeyHierarquia: [1, 2, 3],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 31,
        DbConst.kDbDataAssuntoKeyTitulo: 'Frações',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 32,
        DbConst.kDbDataAssuntoKeyTitulo: 'Lógica',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 33,
        DbConst.kDbDataAssuntoKeyTitulo: 'Combinatória',
        DbConst.kDbDataAssuntoKeyHierarquia: [],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 34,
        DbConst.kDbDataAssuntoKeyTitulo: 'Permutação com repetição',
        DbConst.kDbDataAssuntoKeyHierarquia: [33],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 36,
        DbConst.kDbDataAssuntoKeyTitulo: 'Isometria',
        DbConst.kDbDataAssuntoKeyHierarquia: [1],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 37,
        DbConst.kDbDataAssuntoKeyTitulo: 'Simetria',
        DbConst.kDbDataAssuntoKeyHierarquia: [1, 36],
      },
      {
        DbConst.kDbDataAssuntoKeyId: 39,
        DbConst.kDbDataAssuntoKeyTitulo: 'Equações diofantinas',
        DbConst.kDbDataAssuntoKeyHierarquia: [5],
      },
    ];
  }

  @override
  Future<DataCollection> getQuestoes() async {
    return [
      {
        DbConst.kDbDataQuestaoKeyId: '2019PF1N1Q01',
        DbConst.kDbDataQuestaoKeyAno: 2019,
        DbConst.kDbDataQuestaoKeyNivel: 1,
        DbConst.kDbDataQuestaoKeyIndice: 1,
        DbConst.kDbDataQuestaoKeyEnunciado: [
          "Qual é o número que está escondido pelo borrão?",
          "##nl##"
        ],
        DbConst.kDbDataQuestaoKeyGabarito: 0,
        DbConst.kDbDataQuestaoKeyImagensEnunciado: [
          {
            "altura": 42,
            "base64":
                "iVBORw0KGgoAAAANSUhEUgAAAJsAAAAqCAMAAACTKdluAAABAlBMVEX/+9ZSTkfo5MOPi3lbV0/s6Mf59dGiI44xLSz9+dRDPzqVkX5JRUD08M3l4cA/Ozd5dWf57dGjJo9PS0S7t57v68ny7sujn4nLx6uxrZWcmIQ1MS86NjMuKimHg3K2spqoMZPIeqtYVExoZFnOyq7i3r728s6aloJybmHpyMX789OvQpjWm7biucDerbzZ1bbFwablv8K8YKKtqZLW0rSBfW2/u6EjHyDAvKJOSkPTz7CmK5HRj7K/Z6X25s/04s7UlrTsz8fw2MrqzMbu1cn89tSrOJXZobjgtL7Mha9iXlNVUUne2rrb17jAaaW4WJ+2UZ2qppCMiHcnIyO3VJ7DcKc4Zo8ZAAAC/ElEQVQYGe3A51biCBiA4TfFfKTQSZAiRaQrYMG1Djas49Td+7+VNWH2rCYw58yPOZMfPrx79zvc7xBbzdwVcfUgn4irbcnNWBicnZvEyb3IPwQuhyIz4qQvIjuAuZ0Tyc3583bPLz4Q2BGR3Pb13VBeDImBc5HTsyzAtrzSJAYe5EWjuTvbbcgr98RAX5a6IgaystSAGJjLMqcmEfstUFubvgIhnu0odocws65besFkXswfa0miOpku0LHzjuYR0ZelPhBilioKuEXbtluVdUJqVqlufSPssNo9sKsT9tOlo+OpSZg3/a6BObUKBesbCx3VZMHck6UueMvIVDYVAql8kRCvVwTtySMk0zIx9FpHr0HdahPyMe+kNXi2jqBkGwQOHZWFHVnh08X2jP95xeeygm+eeUyyhNfqmQC1hC+PzzTAzdttqw7P6SNCxkVV16CeVyf1NX44dFQC2VtZ7YI3ygq+rWqBJbTEcQpfe913wg+mbY3H6Qmk0iUiDF2DoqMrVnUdoPO1m6lq3SOApqzWmPFGWcFXU1x8xlrAZeGkoLdcIuZ2pcQ4PYGUVQKMtYDLgqFrYH8vmkZP7wBuRs9v6HoXuJHVTvu8VVYAVKdMYD8RqPCfg/QEYLrhOyZgTKsFSFkF+JguAPuJQIUFQ9fgazoFdStF4NBR8Z3JSo1LQsoKQKE6JkLNrEM7XQdob/kO8CUz1hbgKV2YpA+IMHQNjqpjKOVdAoeOim90Kis0bggrKwC2s0ZE8rGlGjWnTUixsn9yctKme9z2ehmDCEPXwHvKJNf0KQvtUpLAoH/WkGX6RJQVgMzjnKjnzY2Es06Im//L18PtbSSe2kQZugYcKIlKzyUqO5SoJr9KVU1+wk2Z/ITqsdSORF0TDzOJ2iUeshJ1TjzMZIk7YuFSXuT+vpXXcjfEwUhEPl+R3ZMXw9HV9ag5lNw9cXAnsjcAsg0RuSQwzxILI9kb4LsQuTWJlcHIJJDNyRfiak++EFe78pnYaj7w7t27Ff4FTyZSul5FGRwAAAAASUVORK5CYII=",
            "largura": 155
          }
        ],
        DbConst.kDbDataQuestaoKeyAssuntos: [11],
        DbConst.kDbDataQuestaoKeyAlternativas: [
          {
            "id_tipo": 0,
            "conteudo": "10",
            "id_questao": "2019PF1N1Q01",
            "sequencial": 0
          },
          {
            "id_tipo": 0,
            "conteudo": "11",
            "id_questao": "2019PF1N1Q01",
            "sequencial": 1
          },
          {
            "id_tipo": 0,
            "conteudo": "12",
            "id_questao": "2019PF1N1Q01",
            "sequencial": 2
          },
          {
            "id_tipo": 0,
            "conteudo": "13",
            "id_questao": "2019PF1N1Q01",
            "sequencial": 3
          },
          {
            "id_tipo": 0,
            "conteudo": "14",
            "id_questao": "2019PF1N1Q01",
            "sequencial": 4
          }
        ],
      },
      {
        DbConst.kDbDataQuestaoKeyId: '2019PF1N1Q02',
        DbConst.kDbDataQuestaoKeyAno: 2019,
        DbConst.kDbDataQuestaoKeyNivel: 1,
        DbConst.kDbDataQuestaoKeyIndice: 2,
        DbConst.kDbDataQuestaoKeyEnunciado: [
          "A figura abaixo foi formada com pizzas de mesmo tamanho, cada uma dividida em oito pedaços iguais. Quantas pizzas inteiras é possível formar com esses pedaços?",
          "##nl##"
        ],
        DbConst.kDbDataQuestaoKeyGabarito: 2,
        DbConst.kDbDataQuestaoKeyImagensEnunciado: [
          {
            "altura": 151,
            "base64":
                "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",
            "largura": 151
          }
        ],
        DbConst.kDbDataQuestaoKeyAssuntos: [31],
        DbConst.kDbDataQuestaoKeyAlternativas: [
          {
            "id_tipo": 0,
            "conteudo": "3",
            "id_questao": "2019PF1N1Q02",
            "sequencial": 0
          },
          {
            "id_tipo": 0,
            "conteudo": "4",
            "id_questao": "2019PF1N1Q02",
            "sequencial": 1
          },
          {
            "id_tipo": 0,
            "conteudo": "5",
            "id_questao": "2019PF1N1Q02",
            "sequencial": 2
          },
          {
            "id_tipo": 0,
            "conteudo": "6",
            "id_questao": "2019PF1N1Q02",
            "sequencial": 3
          },
          {
            "id_tipo": 0,
            "conteudo": "7",
            "id_questao": "2019PF1N1Q02",
            "sequencial": 4
          }
        ],
      },
      /* {
        DbConst.kDbDataQuestaoKeyId: '2019PF1N1Q01',
        DbConst.kDbDataQuestaoKeyAno: 2019,
        DbConst.kDbDataQuestaoKeyNivel: 1,
        DbConst.kDbDataQuestaoKeyIndice: 1,
        DbConst.kDbDataQuestaoKeyEnunciado: ,
        DbConst.kDbDataQuestaoKeyGabarito: ,
        DbConst.kDbDataQuestaoKeyImagensEnunciado: ,
        DbConst.kDbDataQuestaoKeyAssuntos: ,
        DbConst.kDbDataQuestaoKeyAlternativas: ,
      } */
    ];
  }
/* 
  @override
  Future<DataClube> enterClube(String accessCode, int idUser) {
    // TODO: implement enterClube
    throw UnimplementedError();
  }

  @override
  Future<bool> exitClube(int idClube, int idUser) {
    // TODO: implement exitClube
    throw UnimplementedError();
  }

  @override
  Future<DataCollection> getAtividades(int idClube) {
    // TODO: implement getAtividades
    throw UnimplementedError();
  }

  @override
  Future<DataCollection> getClubes(int idUsuario) {
    // TODO: implement getClubes
    throw UnimplementedError();
  }

  @override
  Future<bool> insertAssunto(DataDocument data) {
    // TODO: implement insertAssunto
    throw UnimplementedError();
  }

  @override
  Future<DataClube> insertClube(
      {required String nome,
      required int proprietario,
      required String codigo,
      String? descricao,
      bool privado = false,
      List<int>? administradores,
      List<int>? membros,
      String? capa}) {
    // TODO: implement insertClube
    throw UnimplementedError();
  }

  @override
  Future<bool> insertQuestao(DataDocument data) {
    // TODO: implement insertQuestao
    throw UnimplementedError();
  }

  @override
  Future<DataClube> updateClube(DataClube data) {
    // TODO: implement updateClube
    throw UnimplementedError();
  }

  @override
  Future<bool> updatePermissionUserClube(
      int idClube, int idUser, int idPermission) {
    // TODO: implement updatePermissionUserClube
    throw UnimplementedError();
  } */
}
