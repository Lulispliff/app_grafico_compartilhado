class MoedaApi {
  late double? bid;
  late DateTime? timestamp;

  MoedaApi({
    this.bid,
    this.timestamp,
  });

  factory MoedaApi.fromMap(Map<String, dynamic> map) {
    return MoedaApi(
      bid: map['bid'],
      timestamp: map['timestamp'],
    );
  }
}
