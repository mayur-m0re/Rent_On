import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'electronics_screen.dart'; // Import the ElectronicsScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.chair_alt, 'label': 'Furniture'},
    {'icon': Icons.devices_other, 'label': 'Electronics'},
    {'icon': Icons.pedal_bike, 'label': 'Tools'},
  ];

  final List<Map<String, dynamic>> featuredItems = [
    {
      'title': '1BHK Apartment',
      'price': '₹10,000/month',
      'image':
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Honda City 2022',
      'price': '₹2,500/day',
      'image':
      'https://images.unsplash.com/photo-1542362567-b07e54358753?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'iPhone 14 Pro',
      'price': '₹1,200/day',
      'image':
      'https://images.unsplash.com/photo-1673435995151-8b5b90b3e8f9?auto=format&fit=crop&w=800&q=60'
    },
  ];

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      // Home
      context.go('/renter/home');
    } else if (index == 1) {
      // Saved
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved items feature coming soon!')),
      );
    } else if (index == 2) {
      // Profile
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'RentOn',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.blueAccent),
                  hintText: 'Search rentals...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Categories
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return GestureDetector(
                    onTap: () {
                      if (cat['label'] == 'Electronics') {
                        // Navigate to Electronics screen
                        context.go('/electronics');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${cat['label']} category coming soon!')),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                          Icon(cat['icon'], color: Colors.blueAccent, size: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['label'],
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),

            // Featured Rentals
            const Text(
              'Featured Rentals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = featuredItems[index];
                  return GestureDetector(
                    onTap: () {
                      context.go('/item/$index'); // Navigate to item detail page
                    },
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              item['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['price'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
