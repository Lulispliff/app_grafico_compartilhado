// ignore: file_names
class CotacoesAPI {
  late String name;
  late DateTime timestamp;
  late double bid;

  CotacoesAPI({
    required this.name,
    required this.timestamp,
    required this.bid,
  });

  CotacoesAPI.fromJson(Map<String, dynamic> json) {
    name = json.containsKey('name') ? json['name'] : "não econtrado";
    timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['timestamp']) * 1000);
    bid = double.parse(json['bid']);
  }

  static List<CotacoesAPI> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CotacoesAPI.fromJson(json)).toList();
  }
}
