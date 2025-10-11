import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ElectronicsScreen extends StatelessWidget {
  const ElectronicsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> electronicsItems = const [
    {
      'title': 'Camera & Photography Equipment',
      'desc': 'Professional cameras and accessories',
      'image':
      'https://images.unsplash.com/photo-1673435995151-8b5b90b3e8f9?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Power Tools & Hardware',
      'desc': 'Durable tools for all projects',
      'image':
      'https://images.unsplash.com/photo-1587825140708-636a4d07311f?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Computers & IT Equipment',
      'desc': 'High-performance computing gear',
      'image':
      'https://images.unsplash.com/photo-1519183071298-a2962f1e2b1b?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Audio & Visual Equipment',
      'desc': 'Premium sound and display systems',
      'image':
      'https://images.unsplash.com/photo-1590650046871-92c887180603?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Industrial & Construction Equipment',
      'desc': 'Heavy-duty machinery',
      'image':
      'https://images.unsplash.com/photo-1504307651254-35680f3567d7?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Lab & Technical Equipment',
      'desc': 'Precision instruments for research',
      'image':
      'https://images.unsplash.com/photo-1584479635035-3b2d5898e2a0?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Consumer Electronics',
      'desc': 'Everyday tech essentials',
      'image':
      'https://images.unsplash.com/photo-1550009158-9c7069c0a0c8?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Event Equipment',
      'desc': 'Gear for memorable events',
      'image':
      'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Electrical & Climate Control Equipment',
      'desc': 'Climate solutions and electrical gear',
      'image':
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=60'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.go('/renter/home'),
        ),
        title: const Text(
          'Electronics',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: electronicsItems.length,
          itemBuilder: (context, index) {
            final item = electronicsItems[index];
            return GestureDetector(
              onTap: () {
                // Implement navigation to detail screen
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['desc']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}