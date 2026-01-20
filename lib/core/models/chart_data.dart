class ChartData {
  final DateTime timestamp;
  final double price;

  ChartData({required this.timestamp, required this.price});

  factory ChartData.fromJson(List<dynamic> json) {
    return ChartData(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[0]),
      price: json[1].toDouble(),
    );
  }
}

class MarketChart {
  final List<ChartData> prices;
  final List<ChartData> marketCaps;
  final List<ChartData> totalVolumes;

  MarketChart({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  factory MarketChart.fromJson(Map<String, dynamic> json) {
    return MarketChart(
      prices: (json['prices'] as List)
          .map((e) => ChartData.fromJson(e))
          .toList(),
      marketCaps: (json['market_caps'] as List)
          .map((e) => ChartData.fromJson(e))
          .toList(),
      totalVolumes: (json['total_volumes'] as List)
          .map((e) => ChartData.fromJson(e))
          .toList(),
    );
  }

  double get minPrice =>
      prices.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  double get maxPrice =>
      prices.map((e) => e.price).reduce((a, b) => a > b ? a : b);
}
