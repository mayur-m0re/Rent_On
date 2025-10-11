import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  String? email;
  List<Map<String, dynamic>> myListings = [];
  late DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    _loadOwnerData();
  }

  Future<void> _loadOwnerData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() => email = user.email);
      await _fetchOwnerDetails(user.uid);
    } else {
      context.go('/login');
    }
  }

  Future<void> _fetchOwnerDetails(String ownerId) async {
    try {
      userData = await _firestore.collection('users').doc(ownerId).get();
      email = userData.get("email");
      await _fetchListings(userData.id);
    } catch (e) {
      print('Error loading Owner Details: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchListings(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection('listings')
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final data = snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'title': doc.get('title'),
              'price': doc.get('price'),
              'location': doc['description'] ?? 'Unknown',
              'image':
                  doc.get('imageUrls') != null &&
                      (doc['imageUrls'] as List).isNotEmpty
                  ? doc.get('imageUrls')[0]
                  : 'https://media.wired.com/photos/632119a7f1e5c40d2b1bc647/master/pass/iPhone-14-Pro-Review-Gear.jpg',
            },
          )
          .toList();

      log(data.toString());
      setState(() {
        myListings = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading listings: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Owner Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newListing = await context.push('/owner/add-listing');
          if (newListing != null) {
            setState(() {
              myListings.add(newListing as Map<String, dynamic>);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Listing'),
        backgroundColor: Colors.blueAccent,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _fetchListings(userData.id),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Owner Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email ?? 'Owner',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Property Owner',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Stats
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatCard(
                          'Listings',
                          myListings.length.toString(),
                          Icons.home_work_outlined,
                        ),
                        _buildStatCard('Bookings', '0', Icons.book_online),
                        _buildStatCard('Views', '0', Icons.visibility_outlined),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // My Listings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Listings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final newListing = await context.push(
                              '/owner/add-listing',
                            );
                            if (newListing != null) {
                              setState(() {
                                myListings.add(
                                  newListing as Map<String, dynamic>,
                                );
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.blueAccent,
                          ),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (myListings.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.hourglass_empty,
                                size: 70,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No listings yet!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myListings.length,
                        itemBuilder: (context, index) {
                          final item = myListings[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${item['location']} • ₹${item['price']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
