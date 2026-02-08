import 'package:flutter/material.dart';

class UserMenuAction extends StatelessWidget {
  const UserMenuAction({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person_outline),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            // TODO: Navigate to profile page
            break;

          case 'logout':
            // TODO: Call AuthService.logout()
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