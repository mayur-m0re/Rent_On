import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/widgets/custom_card.dart';
import '../../models/item_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'add_item_screen.dart';

class OwnerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Owner Dashboard')),
      body: StreamBuilder<List<RentalItem>>(
        stream: db.streamItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final items = snapshot.data!
              .where((i) => i.ownerId == auth.user?.uid)
              .toList();
          if (items.isEmpty) return Center(child: Text('No items. Add one!'));
          return ListView(
            children: items.map((i) => CustomCard(item: i)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => AddItemScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
