// admin_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_providers.dart';

class AdminStatsScreen extends ConsumerWidget {
  const AdminStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (stats) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StatCard(
                title: 'Total Categories',
                value: stats['categories'].toString(),
                icon: Icons.category,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              StatCard(
                title: 'Total Questions',
                value: stats['questions'].toString(),
                icon: Icons.question_answer,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              StatCard(
                title: 'Featured Questions',
                value: stats['featuredQuestions'].toString(),
                icon: Icons.star,
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}