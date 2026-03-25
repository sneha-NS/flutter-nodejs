import 'package:flutter_test/flutter_test.dart';
import 'package:task2/models/todo.dart';

void main() {
  group('Todo model', () {
    test('creates with default isCompleted = false', () {
      final todo = Todo(id: '1', title: 'Buy milk');
      expect(todo.isCompleted, isFalse);
    });

    test('stores id and title correctly', () {
      final todo = Todo(id: 'abc-123', title: 'Walk the dog');
      expect(todo.id, 'abc-123');
      expect(todo.title, 'Walk the dog');
    });

    test('isCompleted can be set to true', () {
      final todo = Todo(id: '2', title: 'Read a book');
      todo.isCompleted = true;
      expect(todo.isCompleted, isTrue);
    });
  });
}
