import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:isar/isar.dart';
part 'cotacao_model.g.dart';

@Collection()
class Cotacoess {
  Id id = Isar.autoIncrement;
  late DateTime data;
  late DateTime hora;
  late double valor;
  late bool isSelected = false;

  final moedaLink = IsarLink<Moeda>();

  Cotacoess({required this.data, required this.hora, required this.valor});
}
