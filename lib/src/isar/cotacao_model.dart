import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:intl/intl.dart';
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
  @ignore
  late Moeda? moeda;

  Cotacoess(
      {required this.nome,
      required this.data,
      required this.hora,
      this.moeda,
      required this.valor});

  factory Cotacoess.fromJson(Map<String, dynamic> map) {
    int timeStamp = int.parse(map['timestamp']);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateFormat timeFormat = DateFormat('HH:mm:ss');

    DateTime data = DateTime.parse(dateFormat.format(dateTime));
    DateTime hora = DateTime.parse(timeFormat.format(dateTime));

    return Cotacoess(
      nome: map['nome'],
      data: data,
      hora: hora,
      valor: map['bid'],
    );
  }
}
//beatch