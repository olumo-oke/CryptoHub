import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cryptocurrency.dart';
import '../models/chart_data.dart';

class CryptoApiService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  Map<String, String> get _headers {
    final apiKey = dotenv.env['COINGECKO_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      return {'x-cg-demo-api-key': apiKey};
    }
    return {};
  }

  // Fetch list of cryptocurrencies with market data
  Future<List<CryptoCurrency>> getCryptocurrencies({
    int page = 1,
    int perPage = 50,
    bool includeSparkline = true,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=$includeSparkline&price_change_percentage=24h',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoCurrency.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load cryptocurrencies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching cryptocurrencies: $e');
    }
  }

  // Fetch specific cryptocurrency details
  Future<CryptoCurrency> getCryptocurrencyDetails(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&ids=$coinId&sparkline=true',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return CryptoCurrency.fromJson(data[0]);
        } else {
          throw Exception('Cryptocurrency not found');
        }
      } else {
        throw Exception(
          'Failed to load cryptocurrency details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching cryptocurrency details: $e');
    }
  }

  // Fetch market chart data for a specific cryptocurrency
  Future<MarketChart> getMarketChart(String coinId, {int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=$days',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MarketChart.fromJson(data);
      } else {
        throw Exception('Failed to load market chart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching market chart: $e');
    }
  }

  // Search cryptocurrencies
  Future<List<CryptoCurrency>> searchCryptocurrencies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&sparkline=true',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final allCryptos = data
            .map((json) => CryptoCurrency.fromJson(json))
            .toList();

        // Filter by query
        return allCryptos.where((crypto) {
          return crypto.name.toLowerCase().contains(query.toLowerCase()) ||
              crypto.symbol.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        throw Exception(
          'Failed to search cryptocurrencies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching cryptocurrencies: $e');
    }
  }

  // Get trending cryptocurrencies
  Future<List<CryptoCurrency>> getTrendingCryptocurrencies() async {
    try {
      // Get top 10 by volume
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=volume_desc&per_page=10&page=1&sparkline=true',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoCurrency.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load trending cryptocurrencies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending cryptocurrencies: $e');
    }
  }
}
