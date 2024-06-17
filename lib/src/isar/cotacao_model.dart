import 'package:isar/isar.dart';
part 'cotacao_model.g.dart';

@Collection()
class Cotacoess {
  Id id = Isar.autoIncrement;
  late String nome;
  late DateTime data;
  late DateTime hora;
  late double valor;
  late bool isSelected = false;

  Cotacoess(
      {required this.nome,
      required this.data,
      required this.hora,
      required this.valor});

  factory Cotacoess.fromJson(Map<String, dynamic> map) {
    int timeStamp = int.parse(map['timestamp']);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

    DateTime data = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime hora =
        DateTime(0, 1, 1, dateTime.hour, dateTime.minute, dateTime.second);

    return Cotacoess(
      nome: map['nome'],
      data: data,
      hora: hora,
      valor: map['bid'],
    );
  }
}
