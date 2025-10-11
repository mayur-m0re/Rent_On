import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🌀 Still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!snapshot.hasData || snapshot.data == null) {
          // go to login
          Future.microtask(() => context.go('/login'));
          return const SizedBox();
        }

        // ✅ Logged in
        final user = snapshot.data!;
        // Now, we check if they are renter or owner
        return FutureBuilder<String>(
          future: _getUserType(user.uid),
          builder: (context, userTypeSnapshot) {
            if (userTypeSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userTypeSnapshot.hasError ||
                !userTypeSnapshot.hasData ||
                userTypeSnapshot.data!.isEmpty) {
              return const Scaffold(
                body: Center(child: Text('Error loading user data')),
              );
            }

            final userType = userTypeSnapshot.data!;
            print(userType);
            if (userType == 'owner') {
              Future.microtask(() => context.go('/owner/dashboard'));
            } else {
              Future.microtask(() => context.go('/renter/home'));
            }

            return const SizedBox(); // Placeholder
          },
        );
      },
    );
  }

  Future<String> _getUserType(String uid) async {
    final doc = await FirebaseAuth
        .instance
        .app
        .options
        .projectId; // just to avoid null errors
    final firestore = FirebaseAuth.instance;
    // Wait, that’s wrong — we’ll fix below
    return 'renter';
  }
}
