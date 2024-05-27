class MoedaApi {
  final String code;
  final String codein;
  final String name;
  final double high;
  final double low;
  final double varBid;
  final double pctChange;
  final double bid;
  final double ask;
  final DateTime timestamp;
  final DateTime createDate;

  MoedaApi({
    required this.code,
    required this.codein,
    required this.name,
    required this.high,
    required this.low,
    required this.varBid,
    required this.pctChange,
    required this.bid,
    required this.ask,
    required this.timestamp,
    required this.createDate,
  });

  factory MoedaApi.fromMap(Map<String, dynamic> map) {
    return MoedaApi(
      code: map['code'],
      codein: map['codein'],
      name: map['name'],
      high: map['high'],
      low: map['low'],
      varBid: map['varBid'],
      pctChange: map['pctChange'],
      bid: map['bid'],
      ask: map['ask'],
      timestamp: map['timestamp'],
      createDate: map['createDate'],
    );
  }
}
