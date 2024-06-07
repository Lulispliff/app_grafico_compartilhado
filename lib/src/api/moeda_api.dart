class MoedaApi {
  final double bid;

  final DateTime timestamp;

  MoedaApi({
    required this.bid,
    required this.timestamp,
  });

  factory MoedaApi.fromMap(Map<String, dynamic> map) {
    return MoedaApi(
      bid: map['bid'],
      timestamp: map['timestamp'],
    );
  }
}
