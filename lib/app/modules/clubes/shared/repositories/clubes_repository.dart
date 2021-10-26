import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/id_base62.dart';
import '../../../../shared/repositories/interface_db_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import '../../../perfil/models/userapp.dart';
import '../models/clube.dart';

part 'clubes_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos clubes.
class ClubesRepository = _ClubesRepositoryBase with _$ClubesRepository;

abstract class _ClubesRepositoryBase with Store implements Disposable {
  final IDbRepository dbRepository;
  final UserApp user;
  final _disposers = <ReactionDisposer>[];

  _ClubesRepositoryBase(this.dbRepository, this.user) {
    _disposers.add(
      autorun(
        (_) {
          if (user.id == null)
            _cleanClubes();
          else
            carregarClubes();
        },
      ),
    );
  }

  /// Lista com os clubes já carregadas.
  @observable
  ObservableList<Clube> _clubes = <Clube>[].asObservable();

  /// Lista com os clubes já carregadas.
  @computed
  List<Clube> get clubes => _clubes;

  /// Lista com os clubes já carregadas.
  /// A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<List<Clube>> get clubesAsync =>
      asyncWhen((_) => _clubes.isNotEmpty).then((_) => _clubes);

  /// Adiciona um novo [Clube] a [clubes].
  @action
  void _addInClubes(Clube clube) {
    if (!_existeClube(clube.id)) _clubes.add(clube);
  }

  /// Limpar a lista de clubes.
  @action
  void _cleanClubes() => _clubes.clear();

  /// Retorna `true` se um [Clube] com o mesmo [id] já tiver sido instanciado.
  /// O método `any()` executa um `for` nos elementos de [clubes].
  /// O loop é interrompido assim que a condição for verdadeira.
  bool _existeClube(int id) {
    if (_clubes.isEmpty)
      return false;
    else
      return _clubes.any((element) => element.id == id);
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Buscar os clubes no banco de dados e carregar na lista [clubes],
  /// caso ainda não tenham sido carregados.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  @action
  Future<List<Clube>> carregarClubes() async {
    if (user.id != null) {
      DataCollection resultado;
      try {
        // Aguardar o retorno dos clubes.
        resultado = await dbRepository.getClubes(user.id!);
      } catch (e) {
        assert(Debug.printBetweenLine(
            "Erro a buscar os dados da coleção ${CollectionType.clubes.name}."));
        assert(Debug.print(e));
        return List<Clube>.empty();
      }
      if (resultado.isEmpty) return List<Clube>.empty();

      // Carregar os clubes.
      for (var map in resultado) {
        if (!_existeClube(map[DbConst.kDbDataClubeKeyId])) {
          // Criar um `Clube` com base no `map` e incluir na lista de questões carregadas.
          // Não será emitido várias notificações, pois `carregarClubes` também é um `action`.
          _addInClubes(Clube.fromDataClube(map));
        }
      }
    }
    return _clubes;
  }

  /// Criar um novo clube com as informações dos parâmetros.
  /// Se o processo for bem sucedido, retorna o [Clube] criado.
  @action
  Future<Clube?> criarClube(
    String nome,
    String? descricao,
    String? capa,
    bool privado, {
    List<int>? administradores,
    List<int>? membros,
  }) async {
    if (user.id == null) return null;
    final proprietario = user.id!;
    final codigo = IdBase62.getIdClube();
    final dataClube = await dbRepository.insertClube(
      nome: nome,
      proprietario: proprietario,
      codigo: codigo,
      descricao: descricao,
      privado: privado,
      administradores: administradores,
      membros: membros,
      capa: capa,
    );
    if (dataClube.isNotEmpty) {
      final clube = Clube.fromDataClube(dataClube);
      _addInClubes(clube);
      return clube;
    } else {
      return null;
    }
  }

  /// Remove de [clube] o usuário atual.
  @action
  Future<bool> sairClube(Clube clube) async {
    if (user.id == null) return false;
    final sucesso = await dbRepository.exitClube(clube.id, user.id!);
    if (sucesso) {
      _clubes.remove(clube);
      return true;
    } else {
      return false;
    }
  }

  /// Inclui o usuário atual no clube correspondente a [codigo].
  /// Se o processo for bem sucedido, retorna o [Clube] correspondente.
  @action
  Future<Clube?> entrarClube(String codigo) async {
    if (user.id == null) return null;
    final dataClube = await dbRepository.enterClube(codigo, user.id!);
    if (dataClube.isNotEmpty) {
      final temp = Clube.fromDataClube(dataClube);
      final indice = _clubes.indexWhere((clube) => clube.id == temp.id);
      if (indice == -1) {
        _addInClubes(temp);
        return temp;
      } else {
        final clube = _clubes[indice];
        // TODO: Testar se o mobx reconhece essas mudanças.
        clube.sobrescrever(temp);
        return clube;
      }
    } else {
      return null;
    }
  }

  /// Atualiza os dados do clube que foram modificados.
  @action
  Future<Clube?> atualizarClube({
    required Clube clube,
    required String nome,
    required String codigo,
    String? descricao,
    required Color capa,
    required bool privado,
  }) async {
    if (user.id == null) return null;

    if (descricao?.isEmpty ?? false) descricao = null;
    final atualizarDescricao = clube.descricao != descricao;
    // Como `null` é um valor válido para a descrição, para não ser atualizada,
    // ela deve ser envida como uma string vazia,
    if (!atualizarDescricao) descricao = '';

    final atualizarCapa = clube.capa.value != capa.value;
    // Como `null` é um valor válido para a capa, para não ser atualizada,
    // ela deve ser envida como uma string vazia,
    final dataCapa = atualizarCapa ? '${capa.value}' : '';

    final DataClube dados = {
      if (clube.nome != nome) DbConst.kDbDataClubeKeyNome: nome,
      if (clube.codigo != codigo) DbConst.kDbDataClubeKeyCodigo: codigo,
      if (clube.privado != privado) DbConst.kDbDataClubeKeyPrivado: privado,
    };
    if (dados.isEmpty && !atualizarCapa && !atualizarDescricao) {
      assert(Debug.print('[ATTENTION] Não há dados para serem atualizados.'));
      return clube;
    }
    dados[DbConst.kDbDataClubeKeyId] = clube.id;
    dados[DbConst.kDbDataClubeKeyDescricao] = descricao;
    dados[DbConst.kDbDataClubeKeyCapa] = dataCapa;

    final dataResult = await dbRepository.updateClube(dados);
    if (dataResult.isNotEmpty) {
      final temp = Clube.fromDataClube(dataResult);
      final indice = _clubes.indexWhere((clube) => clube.id == temp.id);
      if (indice == -1) {
        return null;
      } else {
        final clube = _clubes[indice];
        clube.sobrescrever(temp);
        return clube;
      }
    } else {
      return null;
    }
  }

  /// Encerrar as reações em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}
