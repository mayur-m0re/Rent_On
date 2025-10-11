import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({Key? key}) : super(key: key);

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String title = '';
  String price = '';
  String description = '';
  List<File> imageFiles = [];
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        imageFiles.addAll(pickedFiles.map((p) => File(p.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => imageFiles.removeAt(index));
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      context.go('/login');
      return;
    }

    try {
      final listingRef = _firestore.collection('listings').doc();

      List<String> imageUrls = [];
      for (int i = 0; i < imageFiles.length; i++) {
        final ref = _storage.ref().child('listing_images/${listingRef.id}_$i.jpg');
        final snapshot = await ref.putFile(imageFiles[i]);
        final url = await snapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }

      final newListing = {
        'id': listingRef.id,
        'ownerId': user.uid,
        'title': title,
        'price': price,
        'description': description,
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await listingRef.set(newListing);

      // Clear form
      setState(() {
        title = '';
        price = '';
        description = '';
        imageFiles.clear();
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Listing added successfully!'), backgroundColor: Colors.green),
      );

      // Pass new listing back to dashboard
      Navigator.pop(context, {
        'id': newListing['id'],
        'title': newListing['title'],
        'price': newListing['price'],
        'location': newListing['description'],
        'image': imageUrls.isNotEmpty ? imageUrls[0] : 'https://via.placeholder.com/150?text=No+Image',
      });
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Add New Listing', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.blueAccent, size: 40),
                            SizedBox(height: 10),
                            Text('Tap to upload images', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (imageFiles.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageFiles.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(imageFiles[index], fit: BoxFit.cover, height: 100),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  TextFormField(decoration: _inputDecoration('Listing Title'), validator: (v) => v!.isEmpty ? 'Enter a title' : null, onChanged: (v) => title = v),
                  const SizedBox(height: 16),
                  TextFormField(decoration: _inputDecoration('Price (₹ per day)'), validator: (v) => v!.isEmpty ? 'Enter price' : null, keyboardType: TextInputType.number, onChanged: (v) => price = v),
                  const SizedBox(height: 16),
                  TextFormField(decoration: _inputDecoration('Description'), validator: (v) => v!.isEmpty ? 'Enter description' : null, maxLines: 4, onChanged: (v) => description = v),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveListing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : const Text('Add Listing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
