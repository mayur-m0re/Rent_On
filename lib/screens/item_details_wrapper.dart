import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';
import 'renter/item_details_screen.dart';

class ItemDetailsWrapper extends StatelessWidget {
  final String itemId;
  const ItemDetailsWrapper({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('items').doc(itemId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text('Item not found')));
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final item = RentalItem.fromMap(data);
        return ItemDetailsScreen(item: item);
      },
    );
  }
}
