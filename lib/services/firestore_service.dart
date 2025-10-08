import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
import '../models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<RentalItem>> streamItems() {
    return _db
        .collection('items')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => RentalItem.fromMap(d.data())).toList(),
        );
  }

  Future<void> addItem(RentalItem item) async {
    await _db.collection('items').doc(item.id).set(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _db.collection('items').doc(id).delete();
  }

  Future<void> createBooking(Booking booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toMap());
  }
}
