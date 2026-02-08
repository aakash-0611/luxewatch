import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';


class UserMenuAction extends StatelessWidget {
  const UserMenuAction({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person_outline),
      onSelected: (value) {
        switch (value) {
          case 'profile':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
              ),
          );
            break;
          case 'logout':
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: Text('Profile'),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    );
  }
}