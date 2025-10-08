import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/screens/widgets/custom_card.dart';
import '../../models/item_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Explore')),
      body: StreamBuilder<List<RentalItem>>(
        stream: db.streamItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => context.push('/item/${items[i].id}'),
              child: CustomCard(item: items[i]),
            ),
          );
        },
      ),
      floatingActionButton: auth.user?.role == 'owner'
          ? FloatingActionButton(
              onPressed: () => context.go('/owner/dashboard'),
              child: Icon(Icons.add),
            )
          : null,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Hello, ${auth.user?.name ?? 'Guest'}')),
            ListTile(
              title: Text('Profile'),
              onTap: () => context.go('/profile'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await auth.signOut();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
