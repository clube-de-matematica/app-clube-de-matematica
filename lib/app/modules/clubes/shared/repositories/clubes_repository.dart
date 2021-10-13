import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
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
          _addInClubes(Clube.fromMap(map));
        }
      }
    }
    return _clubes;
  }

  /// Encerrar as reações em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}