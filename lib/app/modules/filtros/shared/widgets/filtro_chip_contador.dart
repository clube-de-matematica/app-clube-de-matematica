import 'package:flutter/material.dart';

///Contador utilizado no componente que apresenta os [Chip] dos filtros selecionados.
class FiltroChipContador extends StatelessWidget {
  FiltroChipContador(this.valor, {Key key, 
  this.primaryColor, this.secondaryColor}) : super(key: key);
  ///Valor mostrado no chip.
  final String valor;
  ///Cor de fundo do chip quando [valor] é "0".
  final Color primaryColor;
  ///Cor de fundo do chip quando [valor] não é "0".
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    final backgroundColor = valor == "0" 
        ? primaryColor ?? tema.colorScheme.onPrimary.withOpacity(0.8) 
        : secondaryColor ?? tema.colorScheme.onSurface;

    final textStyle = valor == "0" 
        ? tema.textTheme.bodyText2 
        : tema.textTheme.bodyText2.copyWith(
          color: tema.colorScheme.onPrimary.withOpacity(0.8)
        );
        
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.all(1),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32), 
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            valor, 
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

///Contador utilizado nos elementos das listas de tipos e opções de filtro das suas 
///respectivas páginas.
class FiltroChipContadorTrailingListTile extends StatelessWidget {
  const FiltroChipContadorTrailingListTile(this.valor, {Key key}) : super(key: key);

  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FiltroChipContador(valor),
        Icon(
          Icons.chevron_right,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        )
      ],
    );
  }
}
