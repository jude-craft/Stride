import 'package:hive/hive.dart';
import 'package:stride/models/todo.dart';

class TodoDatabase {
  static const String _boxName = 'todos';
  
  static Future<Box<Todo>> _getBox() async {
    return await Hive.openBox<Todo>(_boxName);
  }

  static Future<List<Todo>> getAllTodos() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> addTodo(Todo todo) async {
    final box = await _getBox();
    await box.put(todo.id, todo);
  }

  static Future<void> updateTodo(Todo todo) async {
    await todo.save();
  }

  static Future<void> deleteTodo(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  static Future<void> deleteAllCompleted() async {
    final box = await _getBox();
    final completedKeys = box.values
        .where((todo) => todo.isCompleted)
        .map((todo) => todo.id)
        .toList();
    
    for (var key in completedKeys) {
      await box.delete(key);
    }
  }
}