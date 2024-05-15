import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:isar/isar.dart';
part 'cotacao_model.g.dart';

@Collection()
class Cotacoess {
  Id id = Isar.autoIncrement;
  late String nome;
  late DateTime dataHora;
  late double valor;
  late bool isSelected = false;
  @ignore
  late Moeda moeda;
}
