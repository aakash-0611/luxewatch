import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../services/theme_service.dart';
import '../providers/auth_provider.dart';
import '../providers/battery_provider.dart';
import '../providers/connectivity_provider.dart';
import '../main.dart';

import 'login_screen.dart';
import 'orders_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= PROFILE HEADER =================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF121826),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: gold.withOpacity(0.15),
                  child: Icon(Icons.person, size: 32, color: gold),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Consumer<AuthProvider>(
                    builder: (_, auth, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back',
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            auth.name ?? 'User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (auth.email != null)
                            Text(
                              auth.email!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ================= ACCOUNT =================
          const _SectionTitle(title: 'Account'),
          const SizedBox(height: 8),

          _ProfileTile(
            icon: Icons.shopping_bag_outlined,
            label: 'My Orders',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
            },
          ),

          _ProfileTile(
            icon: Icons.favorite_border,
            label: 'Wishlist',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),

          const SizedBox(height: 24),

          // ================= SETTINGS =================
          const _SectionTitle(title: 'Settings'),
          const SizedBox(height: 8),

          // THEME TOGGLE (FIXED + SAVED)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF121826),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: appThemeMode,
              builder: (_, mode, __) {
                final isDark = mode == ThemeMode.dark;

                return ListTile(
                  leading: const Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.white70,
                  ),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) async {
                      final newMode =
                          val ? ThemeMode.dark : ThemeMode.light;

                      appThemeMode.value = newMode;
                      await ThemeService.saveTheme(newMode);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ================= DEVICE STATUS =================
          const _SectionTitle(title: 'Device Status'),
          const SizedBox(height: 8),

          // CONNECTIVITY
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF121826),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Consumer<ConnectivityProvider>(
              builder: (_, net, __) {
                return ListTile(
                  leading: Icon(
                    net.isOnline ? Icons.wifi : Icons.wifi_off,
                    color: net.isOnline
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                  title: const Text('Network'),
                  subtitle: Text(
                    net.isOnline ? 'Connected' : 'Offline',
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              },
            ),
          ),

          // 🔋 BATTERY
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF121826),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Consumer<BatteryProvider>(
              builder: (_, battery, __) {
                return ListTile(
                  leading: Icon(
                    battery.isCharging
                        ? Icons.battery_charging_full
                        : Icons.battery_std,
                    color: battery.isCharging
                        ? Colors.greenAccent
                        : Colors.white70,
                  ),
                  title: const Text('Battery'),
                  subtitle: Text(
                    '${battery.level}%',
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // ================= LOGOUT =================
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.redAccent.withOpacity(0.4),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                await ApiService.clearToken();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= REUSABLE WIDGETS =================

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121826),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(label),
        trailing: trailing ??
            const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }
}
