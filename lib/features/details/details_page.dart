import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/models/cryptocurrency.dart';
import '../../core/theme/app_theme.dart';

class DetailsPage extends StatefulWidget {
  final CryptoCurrency cryptocurrency;

  const DetailsPage({super.key, required this.cryptocurrency});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 1; // Tokens tab selected by default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletAddress(),
            _buildTabBar(),
            _buildTokenInfo(),
            _buildActionButtons(),
            _buildLiquiditySection(),
            _buildVolumeSection(),
            _buildMarketCapSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildWalletAddress() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: AppTheme.greenAccent,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'bc1q0nlydr4l7wxu03q4d5tmmyzqg9jnc9',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          _buildTab('Overview', 0),
          _buildTab('Tokens', 1),
          _buildTab('Pools', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
          _tabController.animateTo(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.lightGray,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: (100 + index * 50).ms),
      ),
    );
  }

  Widget _buildTokenInfo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.surfaceColor,
                child: const Icon(
                  Icons.currency_bitcoin,
                  color: AppTheme.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.cryptocurrency.name}/${widget.cryptocurrency.symbol}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.cryptocurrency.symbol,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppTheme.lightGray),
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.1),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.currentPrice)}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.cryptocurrency.isPriceUp
                      ? AppTheme.redAccent.withOpacity(0.2)
                      : AppTheme.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: AppTheme.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.cryptocurrency.priceChangePercentage24h.abs().toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('VIEW ON STARCOIN'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                  size: 18,
                  color: AppTheme.lightGray,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.star_border,
                  size: 18,
                  color: AppTheme.lightGray,
                ),
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child:
                OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppTheme.primaryBlue,
                          width: 2,
                        ),
                      ),
                      child: const Text('ADD LIQUIDITY'),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 500.ms)
                    .slideX(begin: -0.1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(onPressed: () {}, child: const Text('TRADE'))
                .animate()
                .fadeIn(duration: 400.ms, delay: 600.ms)
                .slideX(begin: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquiditySection() {
    final liquidity = widget.cryptocurrency.totalVolume * 1.35;
    final liquidityChange = widget.cryptocurrency.priceChangePercentage24h;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Liquidity', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(liquidity)}',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: AppTheme.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${liquidityChange.abs().toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms, delay: 700.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildVolumeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Volume 24h', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.totalVolume)}',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppTheme.greenAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12.4%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.greenAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms, delay: 800.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildMarketCapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Market Cap', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(widget.cryptocurrency.marketCap)}',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppTheme.greenAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '21.4%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.greenAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms, delay: 900.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, false),
              _buildNavItem(Icons.show_chart, false),
              _buildNavItem(Icons.swap_horiz, false),
              _buildNavItem(Icons.person_outline, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? AppTheme.primaryBlue : AppTheme.lightGray,
        size: 28,
      ),
      onPressed: () {},
    );
  }
}
