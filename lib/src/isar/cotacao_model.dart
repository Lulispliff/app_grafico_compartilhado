import 'package:isar/isar.dart';
part 'cotacao_model.g.dart';

@Collection()
class Cotacoess {
  Id id = Isar.autoIncrement;
  late String nome;
  late DateTime data;
  late DateTime hora;
  late double valor;

  Cotacoess({
    required this.nome,
    required this.data,
    required this.hora,
    required this.valor,
  });

  factory Cotacoess.fromJson(Map<String, dynamic> map) {
    return Cotacoess(
      nome: map['name'] as String,
      data: DateTime.parse(map['timestamp'] as String),
      hora: DateTime.parse(map['timestamp'] as String),
      valor: (map['bid'] as num).toDouble(),
    );
  }
}
