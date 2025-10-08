import 'package:flutter/material.dart';

import '/models/item_model.dart';

class CustomCard extends StatelessWidget {
  final RentalItem item;
  const CustomCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              child: item.images.isNotEmpty
                  ? Image.network(item.images.first, fit: BoxFit.cover)
                  : Placeholder(),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text('₹${item.pricePerDay.toStringAsFixed(0)}/day'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
