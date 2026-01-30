import 'package:hive/hive.dart';

class Todo extends HiveObject {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  void toggleComplete() {
    isCompleted = !isCompleted;
    completedAt = isCompleted ? DateTime.now() : null;
    save();
  }
}