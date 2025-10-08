import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'renter';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Renter'),
                    leading: Radio(
                      value: 'renter',
                      groupValue: _role,
                      onChanged: (v) => setState(() => _role = v as String),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Owner'),
                    leading: Radio(
                      value: 'owner',
                      groupValue: _role,
                      onChanged: (v) => setState(() => _role = v as String),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      final err = await auth.signUpWithEmail(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _role,
                      );
                      setState(() => _loading = false);
                      if (err != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(err)));
                        return;
                      }
                      if (_role == 'owner')
                        context.go('/owner/dashboard');
                      else
                        context.go('/renter/home');
                    },
              child: Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
