// admin_question_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_providers.dart';
import 'models.dart';

class AdminQuestionEditScreen extends ConsumerStatefulWidget {
  final AdminQuestion? question;

  const AdminQuestionEditScreen({super.key, this.question});

  @override
  ConsumerState<AdminQuestionEditScreen> createState() => _AdminQuestionEditScreenState();
}

class _AdminQuestionEditScreenState extends ConsumerState<AdminQuestionEditScreen> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  late TextEditingController _scholarController;
  late TextEditingController _categoryController;
  late bool _isFeatured;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question?.question ?? '');
    _answerController = TextEditingController(text: widget.question?.answer ?? '');
    _scholarController = TextEditingController(text: widget.question?.scholar ?? '');
    _categoryController = TextEditingController(text: widget.question?.category ?? '');
    _isFeatured = widget.question?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _scholarController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    final firestore = ref.read(firestoreProvider);
    final questionData = {
      'question': _questionController.text.trim(),
      'answer': _answerController.text.trim(),
      'scholar': _scholarController.text.trim(),
      'category': _categoryController.text.trim(),
      'isFeatured': _isFeatured,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      if (widget.question == null) {
        // Add new question
        await firestore.collection('questions').add(questionData);
      } else {
        // Update existing question
        await firestore.collection('questions').doc(widget.question!.id).update(questionData);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving question: $e')),
      );
    }
  }

  Future<void> _deleteQuestion() async {
    if (widget.question == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
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
            .collection('questions')
            .doc(widget.question!.id)
            .delete();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting question: $e')),
        );
      }
    }
  }

  Future<void> _selectCategory() async {
    final categoriesAsync = ref.read(adminCategoriesProvider);
    final categories = categoriesAsync.value ?? [];

    final selectedCategory = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          children: [
            AppBar(
              title: const Text('Select Category'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.title),
                    onTap: () {
                      Navigator.pop(context, category.title);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        _categoryController.text = selectedCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
        actions: [
          if (widget.question != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteQuestion,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _scholarController,
              decoration: const InputDecoration(
                labelText: 'Scholar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: _selectCategory,
                ),
              ),
              readOnly: true,
              onTap: _selectCategory,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Featured Question'),
              value: _isFeatured,
              onChanged: (value) {
                setState(() {
                  _isFeatured = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveQuestion,
                child: const Text('Save Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}