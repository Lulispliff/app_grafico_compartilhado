class CotacoesAPI {
  late String name;
  late DateTime timestamp;
  late double bid;

  CotacoesAPI({
    required this.name,
    required this.timestamp,
    required this.bid,
  });

  // Recebe um mapa com os dados do JSON e inicializa os campos com esses dados recebidos
  CotacoesAPI.fromJson(Map<String, dynamic> json) {
    name = json.containsKey('name') ? json['name'] : 'N/A';
    timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['timestamp']) * 1000);
    bid = double.parse(json['bid']);
  }

  //Converte a lista de dados JSON obtida acima para uma lista de objetos "CotacoesAPI"
  static List<CotacoesAPI> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CotacoesAPI.fromJson(json)).toList();
  }
}
