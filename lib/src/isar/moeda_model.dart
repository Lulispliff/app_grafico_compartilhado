import 'package:isar/isar.dart';
part 'moeda_model.g.dart';

@Collection()
class Moeda {
  Id id = Isar.autoIncrement;
  late String nome;
  DateTime dataHora = DateTime.now();
  double? valor;
}
