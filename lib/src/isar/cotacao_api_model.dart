import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';

class CotacoesAPI {
  late String name;
  late DateTime timestamp;
  late double bid;

  CotacoesAPI({
    required this.name,
    required this.timestamp,
    required this.bid,
  });

  // Converte a lista de dados JSON obtida acima para uma lista de objetos "CotacoesAPI"
  static List<CotacoesAPI> fromJsonList(List<dynamic> jsonList) {
    String? moedaName;

    return jsonList.map((json) {
      if (moedaName == null && json.containsKey('name')) {
        moedaName = StringUtils.editCurrencyName(json['name']);
      }

      return CotacoesAPI.fromJson(json, moedaName);
    }).toList();
  }

  // Recebe um mapa com os dados do JSON e inicializa os campos com esses dados recebidos
  CotacoesAPI.fromJson(Map<String, dynamic> json, String? moedaName) {
    name = json.containsKey('name')
        ? StringUtils.editCurrencyName(json['name'])
        : (moedaName ?? 'N/A');
    timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['timestamp']) * 1000);
    bid = double.parse(json['bid']);
  }

  // Método para converter CotacoesAPI para Cotacacoess
  Cotacoess toCotacoess() {
    return Cotacoess(
      nome: name,
      data: timestamp,
      hora: timestamp,
      valor: bid,
    );
  }
}
