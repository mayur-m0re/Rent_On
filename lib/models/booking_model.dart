class Booking {
  final String id;
  final String itemId;
  final String renterId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Booking({
    required this.id,
    required this.itemId,
    required this.renterId,
    required this.startDate,
    required this.endDate,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'itemId': itemId,
    'renterId': renterId,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'status': status,
  };

  factory Booking.fromMap(Map<String, dynamic> map) => Booking(
    id: map['id'] ?? '',
    itemId: map['itemId'] ?? '',
    renterId: map['renterId'] ?? '',
    startDate: DateTime.parse(map['startDate']),
    endDate: DateTime.parse(map['endDate']),
    status: map['status'] ?? 'pending',
  );
}
