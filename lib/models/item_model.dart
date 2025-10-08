class RentalItem {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String category;
  final double pricePerDay;
  final List<String> images;
  final bool available;

  RentalItem({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.pricePerDay,
    required this.images,
    this.available = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'ownerId': ownerId,
    'title': title,
    'description': description,
    'category': category,
    'pricePerDay': pricePerDay,
    'images': images,
    'available': available,
  };

  factory RentalItem.fromMap(Map<String, dynamic> map) => RentalItem(
    id: map['id'] ?? '',
    ownerId: map['ownerId'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    category: map['category'] ?? '',
    pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
    images: List<String>.from(map['images'] ?? []),
    available: map['available'] ?? true,
  );
}
