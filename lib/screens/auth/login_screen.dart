import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      final err = await auth.signInWithEmail(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      setState(() => _loading = false);
                      if (err != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(err)));
                      } else {
                        final role = auth.user?.role ?? 'renter';
                        if (role == 'owner')
                          context.go('/owner/dashboard');
                        else
                          context.go('/renter/home');
                      }
                    },
              child: Text('Login'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/signup'),
              child: Text('Create account'),
            ),
            SizedBox(height: 12),
            Divider(),
            Text('Or sign in with'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final role = await showDialog<String>(
                      context: context,
                      builder: (_) => _RoleDialog(),
                    );
                    if (role == null) return;
                    setState(() => _loading = true);
                    final err = await auth.signInWithGoogle(role);
                    setState(() => _loading = false);
                    if (err != null)
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(err)));
                    else {
                      final nrole = auth.user?.role ?? 'renter';
                      if (nrole == 'owner')
                        context.go('/owner/dashboard');
                      else
                        context.go('/renter/home');
                    }
                  },
                  child: Text('Google'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose role'),
      content: Text('Sign in as owner or renter?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('renter'),
          child: Text('Renter'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('owner'),
          child: Text('Owner'),
        ),
      ],
    );
  }
}
