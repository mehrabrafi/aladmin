// admin_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Admin Categories Provider
final adminCategoriesProvider = StreamProvider<List<AdminCategory>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('categories')
      .orderBy('order')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => AdminCategory.fromFirestore(doc)).toList();
  });
});

// Admin Questions Provider
final adminQuestionsProvider = StreamProvider<List<AdminQuestion>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('questions')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => AdminQuestion.fromFirestore(doc)).toList();
  });
});

// Admin Stats Provider
final adminStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final firestore = ref.watch(firestoreProvider);

  final categoriesCount = (await firestore.collection('categories').count().get()).count;
  final questionsCount = (await firestore.collection('questions').count().get()).count;
  final featuredQuestionsCount = (await firestore.collection('questions')
      .where('isFeatured', isEqualTo: true)
      .count()
      .get()).count;

  return {
    'categories': categoriesCount,
    'questions': questionsCount,
    'featuredQuestions': featuredQuestionsCount,
  };
});