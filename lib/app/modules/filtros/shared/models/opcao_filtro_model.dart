import 'package:mobx/mobx.dart';

import 'filtros_model.dart';
import '../../../quiz/shared/models/assunto_model.dart';

part 'opcao_filtro_model.g.dart';

///Contém as propriedades das opções apresentadas em [FiltroOpcoesPage].
class OpcaoFiltro = _OpcaoFiltroBase with _$OpcaoFiltro;

abstract class _OpcaoFiltroBase with Store {
  ///Tipo das opções apresentadas em [FiltroOpcoesPage].
  final TiposFiltro tipo;

  ///Será um dos tipos: [Ano], [Assunto], [Dificuldade] ou [Nivel].
  final opcao;

  @observable
  ///Se `true` indica que esta opção está selecionada.
  bool _isSelected = false;
  @computed
  bool get isSelected => _isSelected;

  _OpcaoFiltroBase(this.opcao, this.tipo);

  @action
  ///Se [forcAdd] é `true`, adiciona a opcao ao filtro correspondente e define [_isSelected] 
  ///como `true`. Se [forcRemove] é `true`, remove a opcao do filtro correspondente e define 
  ///[_isSelected] como `false`.
  ///Por padrão, se [_isSelected] é `true` remove a opcao do filtro correspondente.
  ///Se é `false` adiciona. Em seguida alterna o valor de [_isSelected].
  void changeIsSelected(Filtros filtros, {bool forcAdd = false, bool forcRemove = false}) {
    if (forcAdd) {
      filtros.add(this);
      _isSelected = true;
    }
    else if (forcRemove) {
      filtros.remove(this);
      _isSelected = false;
    }
    else {
      _isSelected ? filtros.remove(this) : filtros.add(this);
      _isSelected = !_isSelected;
    }
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is OpcaoFiltro && this.opcao == other.opcao;
  }
}

///******************************************************************************************
///Uma variação de [OpcaoFiltro] para o tipo assunto.
class OpcaoFiltroAssunto = _OpcaoFiltroAssuntoBase with _$OpcaoFiltroAssunto;

abstract class _OpcaoFiltroAssuntoBase extends OpcaoFiltro with Store {
  _OpcaoFiltroAssuntoBase(Assunto opcao) : super(opcao, TiposFiltro.assunto);

  ///Opção selecionada em [FiltroOpcoesPage].
  ///Apenas para que fique tipada como [Assinto].
  Assunto get opcao => super.opcao;

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is OpcaoFiltroAssunto && this.opcao == other.opcao;
  }
}

///******************************************************************************************
///[opcaoFiltro] para as unidades dos assuntos.
///Inclui a propriedade [assuntos] que é a lista de opções de assuntos para a unidade.
class OpcaoFiltroAssuntoUnidade = _OpcaoFiltroAssuntoUnidadeBase 
    with _$OpcaoFiltroAssuntoUnidade;

abstract class _OpcaoFiltroAssuntoUnidadeBase extends OpcaoFiltro with Store {
  _OpcaoFiltroAssuntoUnidadeBase(Assunto opcao, {List<OpcaoFiltroAssunto> assuntos}) 
      : this.assuntos = assuntos ?? List<OpcaoFiltroAssunto>(), 
      super(opcao, TiposFiltro.assunto);

  ///Opção selecionada em [FiltroOpcoesPage].
  ///Apenas para que fique tipada como [Assinto].
  Assunto get opcao => super.opcao;

  ///Lista de opções de assuntos para a unidade.
  final List<OpcaoFiltroAssunto> assuntos;

  @computed
  ///Retorna `true` se todos os assuntos disponíveis para a unidade estiverem selecionados.
  bool get isSelectedAllAsuntos => 
      assuntos.isNotEmpty && numAsuntosSelected == assuntos.length ? true : false;

  @computed
  ///Retorna o número de assuntos selecionados dentre os disponíveis para a unidade.
  int get numAsuntosSelected {
    int contador = 0;
    assuntos.forEach((assunto) {
      if (assunto.isSelected) contador += 1;
    });
    return contador;
  }

  @override
  ///Se a propriedade [isSelected] é `false`, define-a como `true` para a unidade e para 
  ///todos os assuntos disponíveis para ela, caso contrário, denine como `false`.
  void changeIsSelected(Filtros filtros, {bool forcAdd = false, bool forcRemove = false}) {
    assuntos.forEach((assunto) {
      if (isSelected) assunto.changeIsSelected(filtros, forcRemove: true);
      else assunto.changeIsSelected(filtros, forcAdd: true);
    });
    super.changeIsSelected(filtros);
  }

  ///Deve ser chamado semple que um [OpcaoFiltroAssunto] de [assuntos] tiver sua propriedade 
  ///`isSelected` modificada externamente a essa classe.
  void assuntoChanged(Filtros filtros) {
    if (isSelectedAllAsuntos && !isSelected) 
        super.changeIsSelected(filtros, forcAdd: true);
    if (numAsuntosSelected == assuntos.length -1 && isSelected) 
        super.changeIsSelected(filtros, forcRemove: true);
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is OpcaoFiltroAssuntoUnidade && this.opcao == other.opcao;
  }
}