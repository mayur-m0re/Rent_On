import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/item_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  String _category = 'Other';
  final _picker = ImagePicker();
  List<XFile> _images = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context);
    final auth = Provider.of<AuthService>(context);
    final storage = StorageService();

    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _desc,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _price,
              decoration: InputDecoration(labelText: 'Price per day'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Category: '),
                SizedBox(width: 12),
                DropdownButton<String>(
                  value: _category,
                  items: ['Other', 'Camera', 'Vehicle', 'Tools', 'Electronics']
                      .map((c) => DropdownMenuItem(child: Text(c), value: c))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              children: _images
                  .map(
                    (f) => Padding(
                      padding: EdgeInsets.all(4),
                      child: Image.file(
                        File(f.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final x = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (x != null) setState(() => _images.add(x));
                  },
                  child: Text('Pick Image'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final x = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (x != null) setState(() => _images.add(x));
                  },
                  child: Text('Camera'),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      if (_title.text.isEmpty || _price.text.isEmpty) return;
                      setState(() => _loading = true);
                      final id = Uuid().v4();
                      List<String> urls = [];
                      for (var f in _images) {
                        final url = await storage.uploadFile(
                          File(f.path),
                          'items/$id/${DateTime.now().millisecondsSinceEpoch}.jpg',
                        );
                        urls.add(url);
                      }
                      final item = RentalItem(
                        id: id,
                        ownerId: auth.user!.uid,
                        title: _title.text.trim(),
                        description: _desc.text.trim(),
                        category: _category,
                        pricePerDay: double.tryParse(_price.text.trim()) ?? 0.0,
                        images: urls,
                      );
                      await db.addItem(item);
                      setState(() => _loading = false);
                      Navigator.of(context).pop();
                    },
              child: _loading ? CircularProgressIndicator() : Text('Save Item'),
            ),
          ],
        ),
      ),
    );
  }
}
