import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user?.name ?? ''}'),
            SizedBox(height: 8),
            Text('Email: ${user?.email ?? ''}'),
            SizedBox(height: 8),
            Text('Role: ${user?.role ?? ''}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut();
                context.go('/login');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
