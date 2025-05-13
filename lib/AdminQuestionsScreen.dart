// admin_questions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'AdminQuestionEditScreen.dart';
import 'admin_providers.dart';
import 'models.dart';

class AdminQuestionsScreen extends ConsumerWidget {
  const AdminQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(adminQuestionsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminQuestionEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (questions) {
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return QuestionListItem(
                question: question,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminQuestionEditScreen(
                        question: question,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class QuestionListItem extends StatelessWidget {
  final AdminQuestion question;
  final VoidCallback onTap;

  const QuestionListItem({
    super.key,
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(question.question),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.scholar),
            Text(question.category),
            if (question.isFeatured)
              const Chip(
                label: Text('Featured'),
                backgroundColor: Colors.amber,
                labelStyle: TextStyle(color: Colors.black),
              ),
          ],
        ),
        trailing: const Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}