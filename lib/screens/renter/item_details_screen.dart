import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/item_model.dart';

class ItemDetailsScreen extends StatelessWidget {
  final RentalItem item;
  ItemDetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              child: item.images.isNotEmpty
                  ? Image.network(item.images.first, fit: BoxFit.cover)
                  : Placeholder(),
            ),
            SizedBox(height: 12),
            Text(
              item.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(item.description),
            SizedBox(height: 10),
            Text('₹${item.pricePerDay.toStringAsFixed(0)}/day'),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/booking?itemId=${item.id}'),
                    child: Text('Request Booking'),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Proceed to Pay'),
                      content: Text('Payment integration pending.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: Text('Proceed to Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
