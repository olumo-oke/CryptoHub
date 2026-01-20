import 'package:flutter/material.dart';
import '../models/cryptocurrency.dart';
import '../models/chart_data.dart';
import '../services/crypto_api_service.dart';

class CryptoProvider with ChangeNotifier {
  final CryptoApiService _apiService = CryptoApiService();

  List<CryptoCurrency> _cryptocurrencies = [];
  List<CryptoCurrency> _favorites = [];
  List<CryptoCurrency> _trending = [];
  bool _isLoading = false;
  String? _error;

  List<CryptoCurrency> get cryptocurrencies => _cryptocurrencies;
  List<CryptoCurrency> get favorites => _favorites;
  List<CryptoCurrency> get trending => _trending;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Simulated portfolio value
  double _portfolioValue = 1563.00;
  double _portfolioChange = 5432.42;
  double _portfolioChangePercentage = 12.32;

  double get portfolioValue => _portfolioValue;
  double get portfolioChange => _portfolioChange;
  double get portfolioChangePercentage => _portfolioChangePercentage;

  Future<void> loadCryptocurrencies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cryptocurrencies = await _apiService.getCryptocurrencies(perPage: 50);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrending() async {
    try {
      _trending = await _apiService.getTrendingCryptocurrencies();
      notifyListeners();
    } catch (e) {
      // Silently fail for trending
    }
  }

  Future<void> loadFavorites() async {
    try {
      // For demo, load top 3 cryptocurrencies as favorites
      final topCryptos = await _apiService.getCryptocurrencies(perPage: 3);
      _favorites = topCryptos;
      notifyListeners();
    } catch (e) {
      // Silently fail for favorites
    }
  }

  Future<CryptoCurrency> getCryptoDetails(String coinId) async {
    return await _apiService.getCryptocurrencyDetails(coinId);
  }

  Future<MarketChart> getMarketChart(String coinId, int days) async {
    return await _apiService.getMarketChart(coinId, days: days);
  }

  void toggleFavorite(CryptoCurrency crypto) {
    final index = _favorites.indexWhere((c) => c.id == crypto.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(crypto);
    }
    notifyListeners();
  }

  bool isFavorite(String coinId) {
    return _favorites.any((c) => c.id == coinId);
  }

  Future<void> searchCryptos(String query) async {
    if (query.isEmpty) {
      await loadCryptocurrencies();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _cryptocurrencies = await _apiService.searchCryptocurrencies(query);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      loadCryptocurrencies(),
      loadTrending(),
      loadFavorites(),
    ]);
  }

  void buyCrypto(CryptoCurrency crypto, double amount) {
    _portfolioValue += amount;
    notifyListeners();
  }

  void sellCrypto(CryptoCurrency crypto, double amount) {
    _portfolioValue -= amount;
    notifyListeners();
  }
}
