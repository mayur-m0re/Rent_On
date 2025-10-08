class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String photoUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl = '',
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'role': role,
    'photoUrl': photoUrl,
  };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    uid: map['uid'] ?? '',
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    role: map['role'] ?? 'renter',
    photoUrl: map['photoUrl'] ?? '',
  );
}
