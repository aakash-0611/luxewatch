import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/orders_screen.dart';
import '../services/api_service.dart';

class UserMenuAction extends StatelessWidget {
  const UserMenuAction({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person_outline),
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
            break;

          case 'orders':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OrdersScreen(),
              ),
            );
            break;

          case 'logout':
            await ApiService.clearToken();

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (_) => false,
            );
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: Text('Profile'),
        ),
        PopupMenuItem(
          value: 'orders',
          child: Text('My Orders'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    );
  }
}
