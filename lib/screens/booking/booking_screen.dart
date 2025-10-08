import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/booking_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  final String itemId;
  BookingScreen({required this.itemId});
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _start;
  DateTime? _end;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Request Booking')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text('Start date'),
              subtitle: Text(
                _start?.toLocal().toString().split(' ').first ?? 'Not selected',
              ),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (d != null) setState(() => _start = d);
              },
            ),
            ListTile(
              title: Text('End date'),
              subtitle: Text(
                _end?.toLocal().toString().split(' ').first ?? 'Not selected',
              ),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _start ?? DateTime.now(),
                  firstDate: _start ?? DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (d != null) setState(() => _end = d);
              },
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      if (_start == null || _end == null) return;
                      setState(() => _loading = true);
                      final booking = Booking(
                        id: Uuid().v4(),
                        itemId: widget.itemId,
                        renterId: auth.user!.uid,
                        startDate: _start!,
                        endDate: _end!,
                      );
                      await db.createBooking(booking);
                      setState(() => _loading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking request sent')),
                      );
                      Navigator.of(context).pop();
                    },
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
