import 'dart:convert';

import 'package:clubedematematica/app/shared/repositories/firebase/storage_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/debug.dart';
import '../../utils/strings_db.dart';
import '../firebase/firestore_repository.dart';
import '../interface_db_repository.dart';

abstract class FirebaseToSupabase {
  static FirestoreRepository get firebaseDb =>
      Modular.get<FirestoreRepository>();

  static const String _SUPABASE_URL =
      'https://dlhhqapgjuyvzxktohck.supabase.co';
  static const String _SUPABASE_SECRET =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODYxNjA5OSwiZXhwIjoxOTQ0MTkyMDk5fQ.fdCHd5Bx4fBNyo3ENvQF1cb0X0FnucGTepe5SSRL7Q0';

  static Future<Supabase> get _supabase async {
    return Supabase.initialize(
      url: _SUPABASE_URL,
      anonKey: _SUPABASE_SECRET,
    );
  }

  static Future<SupabaseClient> get supabaseClient async =>
      (await _supabase).client;

  static void _print(PostgrestResponse response) {
    if (response.error != null) {
      Debug.printBetweenLine('message: ${response.error?.message}' +
          '\ndetails: ${response.error?.details}' +
          '\nhint: ${response.error?.hint}');
    } else
      Debug.printBetweenLine(response.data);
  }

  static migrarAsuntos() async {
    final client = await supabaseClient;
    final assuntos = await firebaseDb.getCollection(CollectionType.assuntos);

    for (var index = 0; index < assuntos.length; index++) {
      final data = assuntos[index];
      String assunto = data['assunto'];
      String? assuntoPai;
      if (data.containsKey('arvore')) {
        final DataHierarquia hierarquia = List.from(data['arvore']);
        hierarquia.add(assunto);
        for (var i = 0; i < hierarquia.length; i++) {
          if (i > 0) assuntoPai = assunto;
          assunto = hierarquia[i];
          DataAssunto _data = {'assunto': assunto, 'assunto_pai': assuntoPai};
          _print(await client.rpc('inserir_assunto', params: _data).execute());
        }
      } else {
        DataAssunto _data = {'assunto': assunto};
        _print(await client.rpc('inserir_assunto', params: _data).execute());
      }
    }
  }

  static migrarQuestoes() async {
    final client = await supabaseClient;
    final questoes = await firebaseDb.getCollection(CollectionType.questoes);
    final DataCollection questoesReaplicadas = [];
    final imageToBase64 = (String imageName) async {
      final uint8List = await Modular.get<StorageRepository>()
          .storage
          .ref()
          .child(StorageRepository.kRelativePathImages)
          .child(imageName)
          .getData();
      return base64Encode(uint8List!.toList());
    };

    for (var index = 0; index < questoes.length; index++) {
      final oldData = questoes[index];

      if (oldData.containsKey('referencia')) {
        questoesReaplicadas.add(oldData);
        continue;
      }

      final List<String> oldAssuntos =
          (oldData['assuntos'] as List).cast<String>();
      final List<int> assuntos = [];
      final List<DataAlternativa> oldAlternativas =
          (oldData['alternativas'] as List).cast<DataAlternativa>();
      final List<DataAlternativa> alternativas = [];
      final List<DataImagem> imagensEnunciado = [];

      for (var i = 0; i < oldAssuntos.length; i++) {
        final response = await client
            .from('assuntos')
            .select()
            .eq('assunto', oldAssuntos[i])
            .execute();
        assuntos.add(response.data[0]['id']);
      }

      for (var i = 0; i < oldAlternativas.length; i++) {
        final idTipo = oldAlternativas[i]['tipo'] == 'texto' ? 0 : 1;
        final String conteuto;
        final oldValor = oldAlternativas[i]['valor']!;
        if (idTipo == 0)
          conteuto = oldAlternativas[i]['valor']!;
        else {
          conteuto = json.encode({
            'largura': oldValor['largura'],
            'altura': oldValor['altura'],
            'base64': await imageToBase64(oldValor['nome']),
          });
        }
        final DataAlternativa newAlternativa = {
          'sequencial':
              'ABCDE'.indexOf(oldAlternativas[i]['alternativa']!.toUpperCase()),
          'id_tipo': idTipo,
          'conteudo': conteuto,
        };
        alternativas.add(newAlternativa);
      }

      if (oldData.containsKey('imagens_enunciado')) {
        final List<DataImagem> oldImagensEnunciado =
            (oldData['imagens_enunciado'] as List).cast<DataImagem>();
        for (var i = 0; i < oldImagensEnunciado.length; i++) {
          final DataImagem oldImagem = oldImagensEnunciado[i];
          final DataImagem newImagem = {
            'largura': oldImagem['largura'],
            'altura': oldImagem['altura'],
            'base64': await imageToBase64(oldImagem['nome']),
          };
          imagensEnunciado.add(newImagem);
        }
      }

      final DataQuestao newData = {
        'enunciado': oldData['enunciado'],
        'gabarito': 'ABCDE'.indexOf(oldData['gabarito'].toUpperCase()),
        'imagens_enunciado': imagensEnunciado,
        'assuntos': assuntos,
        'alternativas': alternativas,
        'ano': oldData['ano'],
        'nivel': oldData['nivel'],
        'indice': oldData['indice'],
      };

      final response =
          await client.rpc('inserir_questao', params: newData).execute();
      print('old: ' + oldData['id']);
      _print(response);
    }

    for (var index = 0; index < questoesReaplicadas.length; index++) {
      final oldData = questoesReaplicadas[index];
      final String idString = oldData['id'];
      final int idReferencia = (await client
              .from('questoes_caderno')
              .select()
              .eq('id', oldData['referencia'])
              .execute())
          .data[0]['id_questao'];
      final DataQuestao newData = {
        'ano': int.parse(idString.substring(0, 4)),
        'nivel': oldData['nivel'],
        'indice': oldData['indice'],
        'id_referencia': idReferencia,
      };

      final response =
          await client.rpc('inserir_questao', params: newData).execute();

      _print(response);
    }
  }
}
