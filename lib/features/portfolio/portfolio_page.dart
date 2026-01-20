import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../exchange/exchange_page.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTotalBalanceCard(context, isDark),
                    const SizedBox(height: 24),
                    _buildPortfolioChart(context, isDark),
                    const SizedBox(height: 24),
                    _buildQuickActions(context, isDark),
                    const SizedBox(height: 24),
                    _buildAssetsSection(context, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Portfolio',
        style: Theme.of(context).textTheme.displaySmall,
      ).animate().fadeIn(duration: 400.ms),
      actions: [
        IconButton(
          icon: const Icon(Icons.history, size: 28),
          onPressed: () {},
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
      ],
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context, bool isDark) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/web3_portfolio_vault.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hide',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '\$${NumberFormat('#,##0.00').format(45678.90)}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: AppTheme.greenAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+\$${NumberFormat('#,##0.00').format(5432.42)} (12.32%)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.greenAccent,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2)
        .shimmer(duration: 1500.ms, delay: 500.ms);
  }

  Widget _buildPortfolioChart(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBackground : AppTheme.lightCardBackground,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio Distribution',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '7 Assets',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _buildPieChartSections(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartLegend(context, isDark),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
        value: 40,
        color: const Color(0xFFF7931A),
        title: '40%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 25,
        color: const Color(0xFF627EEA),
        title: '25%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 15,
        color: const Color(0xFFF3BA2F),
        title: '15%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 10,
        color: AppTheme.greenAccent,
        title: '10%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 10,
        color: AppTheme.primaryBlue,
        title: '10%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildChartLegend(BuildContext context, bool isDark) {
    final items = [
      {'name': 'Bitcoin', 'symbol': 'BTC', 'color': const Color(0xFFF7931A)},
      {'name': 'Ethereum', 'symbol': 'ETH', 'color': const Color(0xFF627EEA)},
      {
        'name': 'Binance Coin',
        'symbol': 'BNB',
        'color': const Color(0xFFF3BA2F),
      },
      {'name': 'Solana', 'symbol': 'SOL', 'color': AppTheme.greenAccent},
      {'name': 'Others', 'symbol': '', 'color': AppTheme.primaryBlue},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item['name'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            Icons.arrow_downward,
            'Deposit',
            AppTheme.greenAccent,
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            Icons.arrow_upward,
            'Withdraw',
            AppTheme.redAccent,
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            Icons.swap_horiz,
            'Swap',
            AppTheme.primaryBlue,
            isDark,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        if (label == 'Swap') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExchangePage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsSection(BuildContext context, bool isDark) {
    final assets = [
      {
        'name': 'Bitcoin',
        'symbol': 'BTC',
        'amount': '0.5234',
        'value': 18234.50,
        'change': 5.67,
        'color': const Color(0xFFF7931A),
      },
      {
        'name': 'Ethereum',
        'symbol': 'ETH',
        'amount': '3.2145',
        'value': 11456.75,
        'change': -2.34,
        'color': const Color(0xFF627EEA),
      },
      {
        'name': 'Binance Coin',
        'symbol': 'BNB',
        'amount': '15.678',
        'value': 6890.25,
        'change': 8.92,
        'color': const Color(0xFFF3BA2F),
      },
      {
        'name': 'Solana',
        'symbol': 'SOL',
        'amount': '45.234',
        'value': 4567.80,
        'change': 12.45,
        'color': const Color(0xFF14F195),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Assets', style: Theme.of(context).textTheme.titleLarge),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ).animate().fadeIn(duration: 800.ms),
        const SizedBox(height: 12),
        ...assets.asMap().entries.map((entry) {
          final index = entry.key;
          final asset = entry.value;
          return _buildAssetItem(context, asset, index, isDark);
        }),
      ],
    );
  }

  Widget _buildAssetItem(
    BuildContext context,
    Map<String, dynamic> asset,
    int index,
    bool isDark,
  ) {
    final isPositive = (asset['change'] as double) > 0;

    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (asset['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    asset['symbol'] as String,
                    style: TextStyle(
                      color: asset['color'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${asset['amount']} ${asset['symbol']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${NumberFormat('#,##0.00').format(asset['value'])}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isPositive
                                  ? AppTheme.greenAccent
                                  : AppTheme.redAccent)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${(asset['change'] as double).toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isPositive
                            ? AppTheme.greenAccent
                            : AppTheme.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (900 + index * 100).ms)
        .slideX(begin: 0.1);
  }
}
