import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoNotifier() : super(const AsyncValue.loading()) {
    initHive();
  }

  late Box<Todo> _todoBox;

  // Named without underscore so subclasses can override it in tests.
  Future<void> initHive() async {
    try {
      _todoBox = await Hive.openBox<Todo>('todos_box');
      state = AsyncValue.data(_todoBox.values.toList());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    _todoBox.put(newTodo.id, newTodo);
    _updateState();
  }

  void toggleTodo(String id) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      todo.save(); // Persists change in Hive
      _updateState();
    }
  }

  void deleteTodo(String id) {
    _todoBox.delete(id);
    _updateState();
  }

  void _updateState() {
    state = AsyncValue.data(_todoBox.values.toList());
  }
}