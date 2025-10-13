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
      'https://vectips.com/wp-content/uploads/2017/03/project-preview-large-2.png'
    },
    {
      'title': 'Power Tools & Hardware',
      'desc': 'Durable tools for all projects',
      'image':
      'https://cdn-icons-png.flaticon.com/512/4647/4647569.png'
    },
    {
      'title': 'Computers & IT Equipment',
      'desc': 'High-performance computing gear',
      'image':
      'https://cdn-icons-png.flaticon.com/512/3527/3527362.png'
    },
    {
      'title': 'Audio & Visual Equipment',
      'desc': 'Premium sound and display systems',
      'image':
      'https://media.istockphoto.com/id/1999495160/vector/audio-visual-and-headphone-icon-concept.jpg?s=612x612&w=0&k=20&c=WidXoxO6J4Lf0-UAY6gGQSzCqE_FAjeaJTK91hBegu0='
    },
    {
      'title': 'Industrial & Construction Equipment',
      'desc': 'Heavy-duty machinery',
      'image':
      'https://as1.ftcdn.net/jpg/04/77/98/54/1000_F_477985463_bLGK7m8X1WEocr06NjnH6qWUA10ef7jV.jpg'
    },
    {
      'title': 'Lab & Technical Equipment',
      'desc': 'Precision instruments for research',
      'image':
      'https://cdn-icons-png.freepik.com/512/7918/7918229.png'
    },
    {
      'title': 'Consumer Electronics',
      'desc': 'Everyday tech essentials',
      'image':
      'https://cdn-icons-png.flaticon.com/512/11495/11495804.png'
    },
    {
      'title': 'Event Equipment',
      'desc': 'Gear for memorable events',
      'image':
      'https://cdn-icons-png.flaticon.com/512/2037/2037682.png'
    },
    {
      'title': 'Electrical & Climate Control Equipment',
      'desc': 'Climate solutions and electrical gear',
      'image':
      'https://static.vecteezy.com/system/resources/previews/051/837/396/non_2x/a-vacuum-cleaner-with-a-snowflake-on-it-free-vector.jpg'
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