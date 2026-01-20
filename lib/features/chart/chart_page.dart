import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/models/cryptocurrency.dart';
import '../../core/models/chart_data.dart';
import '../../core/providers/crypto_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

class ChartPage extends StatefulWidget {
  final CryptoCurrency cryptocurrency;

  const ChartPage({super.key, required this.cryptocurrency});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int _selectedDays = 7;
  MarketChart? _chartData;
  bool _isLoading = true;
  String _selectedTimeframe = '1W';
  String _chartType = 'Line'; // Line, Area, Candle, Bar

  final Map<String, int> _timeframes = {
    '1H': 1,
    '1D': 1,
    '1W': 7,
    '1M': 30,
    '3M': 90,
    '1Y': 365,
  };

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() => _isLoading = true);
    try {
      final chartData = await context.read<CryptoProvider>().getMarketChart(
        widget.cryptocurrency.id,
        _selectedDays,
      );
      setState(() {
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _changeTimeframe(String timeframe, int days) {
    setState(() {
      _selectedTimeframe = timeframe;
      _selectedDays = days;
    });
    _loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.darkBackground
          : AppTheme.lightBackground,
      appBar: AppBar(
        title: Text('${widget.cryptocurrency.symbol}/USD'),
        actions: [
          Consumer<CryptoProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.cryptocurrency.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? AppTheme.yellow : null,
                ),
                onPressed: () {
                  provider.toggleFavorite(widget.cryptocurrency);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? '${widget.cryptocurrency.name} removed from watchlist'
                            : '${widget.cryptocurrency.name} added to watchlist',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing functionality coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceHeader(isDark),
            _buildChartTypeSelector(isDark),
            _buildTimeframeSelector(isDark),
            _buildChart(isDark),
            _buildPriceStats(isDark),
            _buildStatisticsSection(isDark),
            _buildNewsSection(isDark),
            _buildActionButtons(isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceHeader(bool isDark) {
    final isPositive = widget.cryptocurrency.isPriceUp;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCryptoLogo(widget.cryptocurrency),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cryptocurrency.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      widget.cryptocurrency.symbol.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      (isPositive ? AppTheme.greenAccent : AppTheme.redAccent)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive
                          ? AppTheme.greenAccent
                          : AppTheme.redAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${widget.cryptocurrency.priceChangePercentage24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPositive
                            ? AppTheme.greenAccent
                            : AppTheme.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 20),
          Text(
            '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.currentPrice)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
          const SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : ''}\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.currentPrice * widget.cryptocurrency.priceChangePercentage24h / 100)} Today',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isPositive ? AppTheme.greenAccent : AppTheme.redAccent,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildCryptoLogo(CryptoCurrency crypto) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          crypto.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              child: Center(
                child: Text(
                  crypto.symbol[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartTypeSelector(bool isDark) {
    final chartTypes = ['Line', 'Area', 'Candle', 'Bar'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: chartTypes.map((type) {
            final isSelected = _chartType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _chartType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? const Color(0xFF3D3D3D) : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.white : Colors.black)
                            : (isDark ? Colors.grey : Colors.grey.shade600),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildTimeframeSelector(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _timeframes.entries.map((entry) {
          final isSelected = _selectedTimeframe == entry.key;
          return GestureDetector(
            onTap: () => _changeTimeframe(entry.key, entry.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : isDark
                    ? AppTheme.cardBackground
                    : AppTheme.lightCardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                ),
              ),
              child: Text(
                entry.key,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? AppTheme.lightGray
                      : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ).animate(target: isSelected ? 1 : 0).scale(duration: 200.ms),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildChart(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.cardBackground
              : AppTheme.lightCardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _chartData == null
            ? const Center(child: Text('Failed to load chart'))
            : _buildChartByType(isDark),
      ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildChartByType(bool isDark) {
    switch (_chartType) {
      case 'Area':
        return _buildAreaChart(isDark);
      case 'Candle':
        return _buildCandleChart(isDark);
      case 'Bar':
        return _buildBarChart(isDark);
      default:
        return _buildLineChart(isDark);
    }
  }

  Widget _buildLineChart(bool isDark) {
    final prices = _chartData!.prices;
    if (prices.isEmpty) return const Center(child: Text('No data available'));

    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final minY = _chartData!.minPrice;
    final maxY = _chartData!.maxPrice;
    final range = maxY - minY;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY - (range * 0.1),
        maxY: maxY + (range * 0.1),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: widget.cryptocurrency.isPriceUp
                  ? [
                      AppTheme.greenAccent,
                      AppTheme.greenAccent.withOpacity(0.5),
                    ]
                  : [AppTheme.redAccent, AppTheme.redAccent.withOpacity(0.5)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark
                ? AppTheme.cardBackground
                : AppTheme.lightCardBackground,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${NumberFormat('#,##0.00').format(spot.y)}',
                  TextStyle(
                    color: isDark ? AppTheme.whiteText : AppTheme.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAreaChart(bool isDark) {
    final prices = _chartData!.prices;
    if (prices.isEmpty) return const Center(child: Text('No data available'));

    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final minY = _chartData!.minPrice;
    final maxY = _chartData!.maxPrice;
    final range = maxY - minY;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY - (range * 0.1),
        maxY: maxY + (range * 0.1),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: widget.cryptocurrency.isPriceUp
                  ? [
                      AppTheme.greenAccent,
                      AppTheme.greenAccent.withOpacity(0.5),
                    ]
                  : [AppTheme.redAccent, AppTheme.redAccent.withOpacity(0.5)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: widget.cryptocurrency.isPriceUp
                    ? [
                        AppTheme.greenAccent.withOpacity(0.3),
                        AppTheme.greenAccent.withOpacity(0.05),
                      ]
                    : [
                        AppTheme.redAccent.withOpacity(0.3),
                        AppTheme.redAccent.withOpacity(0.05),
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark
                ? AppTheme.cardBackground
                : AppTheme.lightCardBackground,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${NumberFormat('#,##0.00').format(spot.y)}',
                  TextStyle(
                    color: isDark ? AppTheme.whiteText : AppTheme.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCandleChart(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.candlestick_chart,
            size: 64,
            color: isDark ? AppTheme.lightGray : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Candlestick Chart',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Coming Soon', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBarChart(bool isDark) {
    final prices = _chartData!.prices;
    if (prices.isEmpty) return const Center(child: Text('No data available'));

    // Sample every nth point for bar chart
    final sampleRate = (prices.length / 20).ceil();
    final sampledPrices = <ChartData>[];
    for (int i = 0; i < prices.length; i += sampleRate) {
      sampledPrices.add(prices[i]);
    }

    final minY = _chartData!.minPrice;
    final maxY = _chartData!.maxPrice;
    final range = maxY - minY;

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minY: minY - (range * 0.1),
        maxY: maxY + (range * 0.1),
        barGroups: sampledPrices.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.price,
                color: widget.cryptocurrency.isPriceUp
                    ? AppTheme.greenAccent
                    : AppTheme.redAccent,
                width: 8,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: isDark
                ? AppTheme.cardBackground
                : AppTheme.lightCardBackground,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '\$${NumberFormat('#,##0.00').format(rod.toY)}',
                TextStyle(
                  color: isDark ? AppTheme.whiteText : AppTheme.darkText,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPriceStats(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'High',
              '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.high24h)}',
              Icons.arrow_upward,
              AppTheme.greenAccent,
              isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Low',
              '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.low24h)}',
              Icons.arrow_downward,
              AppTheme.redAccent,
              isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Volume',
              NumberFormat.compact().format(widget.cryptocurrency.totalVolume),
              Icons.bar_chart,
              AppTheme.primaryBlue,
              isDark,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBackground : AppTheme.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.cardBackground
              : AppTheme.lightCardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildStatRow(
              'Market Cap',
              NumberFormat.compact().format(widget.cryptocurrency.marketCap),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              'Circulating Supply',
              NumberFormat.compact().format(
                widget.cryptocurrency.circulatingSupply,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              '24h Volume',
              NumberFormat.compact().format(widget.cryptocurrency.totalVolume),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              '24h High',
              '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.high24h)}',
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              '24h Low',
              '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.low24h)}',
            ),
          ],
        ),
      ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNewsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Latest News', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.cardBackground
                          : AppTheme.lightCardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://picsum.photos/seed/${index + 100}/200',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'CRYPTO NEWS',
                                  style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Market Analysis: ${widget.cryptocurrency.name} shows strong momentum',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2 hours ago',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(
                    duration: 600.ms,
                    delay: Duration(milliseconds: index * 100),
                  )
                  .slideX(begin: 0.1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showTradeDialog(context, false),
              icon: const Icon(Icons.sell),
              label: const Text('SELL'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppTheme.redAccent, width: 2),
                foregroundColor: AppTheme.redAccent,
              ),
            ).animate().fadeIn(duration: 1000.ms).slideX(begin: -0.1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showTradeDialog(context, true),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('BUY'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.greenAccent,
              ),
            ).animate().fadeIn(duration: 1000.ms).slideX(begin: 0.1),
          ),
        ],
      ),
    );
  }

  void _showTradeDialog(BuildContext context, bool isBuy) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('${isBuy ? 'Buy' : 'Sell'} ${widget.cryptocurrency.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (USD)',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Price: \$${widget.cryptocurrency.currentPrice}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                final provider = context.read<CryptoProvider>();
                if (isBuy) {
                  provider.buyCrypto(widget.cryptocurrency, amount);
                } else {
                  provider.sellCrypto(widget.cryptocurrency, amount);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully ${isBuy ? 'bought' : 'sold'} \$${amount.toStringAsFixed(2)} of ${widget.cryptocurrency.symbol.toUpperCase()}',
                    ),
                    backgroundColor: isBuy
                        ? AppTheme.greenAccent
                        : AppTheme.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBuy
                  ? AppTheme.greenAccent
                  : AppTheme.redAccent,
            ),
            child: Text(isBuy ? 'Buy' : 'Sell'),
          ),
        ],
      ),
    );
  }
}
