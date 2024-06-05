class MoedaApi {
  late String? code;
  late String? codein;
  late String? name;
  late double? high;
  late double? low;
  late double? varBid;
  late double? pctChange;
  late double? bid;
  late double? ask;
  late DateTime? timestamp;
  late DateTime? createDate;

  MoedaApi({
    this.code,
    this.codein,
    this.name,
    this.high,
    this.low,
    this.varBid,
    this.pctChange,
    this.bid,
    this.ask,
    this.timestamp,
    this.createDate,
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
