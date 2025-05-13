// admin_category_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_providers.dart';
import 'models.dart';

class AdminCategoryEditScreen extends ConsumerStatefulWidget {
  final AdminCategory? category;

  const AdminCategoryEditScreen({super.key, this.category});

  @override
  ConsumerState<AdminCategoryEditScreen> createState() => _AdminCategoryEditScreenState();
}

class _AdminCategoryEditScreenState extends ConsumerState<AdminCategoryEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late bool _isFeatured;
  late int _order;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.category?.title ?? '');
    _imageUrlController = TextEditingController(text: widget.category?.imageUrl ?? '');
    _isFeatured = widget.category?.isFeatured ?? false;
    _order = widget.category?.order ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    final firestore = ref.read(firestoreProvider);
    final categoryData = {
      'title': _titleController.text.trim(),
      'imageUrl': _imageUrlController.text.trim(),
      'isFeatured': _isFeatured,
      'order': _order,
    };

    try {
      if (widget.category == null) {
        // Add new category
        await firestore.collection('categories').add(categoryData);
      } else {
        // Update existing category
        await firestore.collection('categories').doc(widget.category!.id).update(categoryData);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving category: $e')),
      );
    }
  }

  Future<void> _deleteCategory() async {
    if (widget.category == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(firestoreProvider)
            .collection('categories')
            .doc(widget.category!.id)
            .delete();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
        actions: [
          if (widget.category != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteCategory,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Category Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Featured Category'),
              value: _isFeatured,
              onChanged: (value) {
                setState(() {
                  _isFeatured = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _order.toString(),
              decoration: const InputDecoration(
                labelText: 'Order',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _order = int.tryParse(value) ?? 0;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCategory,
                child: const Text('Save Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}