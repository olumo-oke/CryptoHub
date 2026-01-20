import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

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
                    _buildProfileSection(context, isDark),
                    const SizedBox(height: 32),
                    _buildSettingsSection(context, 'Preferences', [
                      _buildThemeToggle(context, themeProvider),
                      _buildSettingsTile(
                        context,
                        Icons.notifications_outlined,
                        'Notifications',
                        'Manage your notifications',
                        () {},
                        isDark,
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.language_outlined,
                        'Language',
                        'English (US)',
                        () {},
                        isDark,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context, 'Security', [
                      _buildSettingsTile(
                        context,
                        Icons.lock_outline,
                        'Change Password',
                        'Update your password',
                        () {},
                        isDark,
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.fingerprint,
                        'Biometric Lock',
                        'Use fingerprint or face ID',
                        () {},
                        isDark,
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.security_outlined,
                        'Two-Factor Authentication',
                        'Add extra security',
                        () {},
                        isDark,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context, 'About', [
                      _buildSettingsTile(
                        context,
                        Icons.info_outline,
                        'About CryptoHub',
                        'Version 1.0.0',
                        () {},
                        isDark,
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.privacy_tip_outlined,
                        'Privacy Policy',
                        'Read our privacy policy',
                        () {},
                        isDark,
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.description_outlined,
                        'Terms of Service',
                        'Read our terms',
                        () {},
                        isDark,
                      ),
                    ]),
                    const SizedBox(height: 32),
                    _buildLogoutButton(context, isDark),
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
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2),
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.titleLarge,
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildProfileSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppTheme.primaryGradient
            : AppTheme.lightCardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.primaryBlue : Colors.black).withOpacity(
              0.2,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: isDark ? Colors.white : AppTheme.darkText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Natalya Undergrowth',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDark ? Colors.white : AppTheme.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'natalya@cryptohub.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white.withOpacity(0.8)
                        : AppTheme.lightGray,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit, color: isDark ? Colors.white : AppTheme.darkText),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2);
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBackground : AppTheme.lightCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  isDark ? 'Enabled' : 'Disabled',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (value) => themeProvider.setDarkMode(value),
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppTheme.lightGray : Colors.grey,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
    );
  }
}
