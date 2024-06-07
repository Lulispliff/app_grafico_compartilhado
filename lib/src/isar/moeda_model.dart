import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:isar/isar.dart';
part 'moeda_model.g.dart';

@Collection()
class Moeda {
  Id id = Isar.autoIncrement;
  late String nome;
  late String key;
  DateTime dataHora = DateTime.now();
  double? valor;
  @ignore
  List<Cotacoess> cotacoes = [];
}
