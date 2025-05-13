// models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String imageUrl;

  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Category.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Category(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}

class Question {
  final String id;
  final String question;
  final String answer;
  final String scholar;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.scholar,
    required this.category,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      scholar: data['scholar'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'scholar': scholar,
      'category': category,
    };
  }
}

class AdminCategory extends Category {
  final bool isFeatured;
  final int order;

  AdminCategory({
    required String id,
    required String title,
    required String imageUrl,
    this.isFeatured = false,
    this.order = 0,
  }) : super(id: id, title: title, imageUrl: imageUrl);

  factory AdminCategory.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AdminCategory(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      order: data['order'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'order': order,
    };
  }
}

class AdminQuestion extends Question {
  final bool isFeatured;
  final Timestamp timestamp;

  AdminQuestion({
    required String id,
    required String question,
    required String answer,
    required String scholar,
    required String category,
    this.isFeatured = false,
    required this.timestamp,
  }) : super(
    id: id,
    question: question,
    answer: answer,
    scholar: scholar,
    category: category,
  );

  factory AdminQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminQuestion(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      scholar: data['scholar'] ?? '',
      category: data['category'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      timestamp: data['timestamp'] is Timestamp
          ? data['timestamp'] as Timestamp
          : Timestamp.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'scholar': scholar,
      'category': category,
      'isFeatured': isFeatured,
      'timestamp': timestamp,
    };
  }
}