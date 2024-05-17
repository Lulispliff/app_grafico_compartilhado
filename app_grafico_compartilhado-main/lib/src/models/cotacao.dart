import 'package:app_grafico_compartilhado/src/models/indicador.dart';

class Cotacao {
  final DateTime dataHora;
  final double valor;
  final Indicador indicador;
  bool isSelected;

  Cotacao({
    required this.dataHora,
    required this.valor,
    required this.indicador,
    this.isSelected = false,
  });
}
