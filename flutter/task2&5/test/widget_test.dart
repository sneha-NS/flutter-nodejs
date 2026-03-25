import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task2/models/todo.dart';
import 'package:task2/providers/todo_provider.dart';
import 'package:task2/screens/todo_screen.dart';

// ---------------------------------------------------------------------------
// FakeTodoNotifier – extends TodoNotifier, overrides initHive() and all
// Hive-touching methods so tests never touch the filesystem.
// ---------------------------------------------------------------------------
class FakeTodoNotifier extends TodoNotifier {
  final AsyncValue<List<Todo>>? _overrideState;

  // Starts with a pre-populated list.
  FakeTodoNotifier(List<Todo> initial)
      : _overrideState = AsyncValue.data(initial),
        super();

  // Stays in the loading state indefinitely.
  FakeTodoNotifier.loading() : _overrideState = null, super();

  // Immediately transitions to error state.
  FakeTodoNotifier.withError(Object error)
      : _overrideState = AsyncValue.error(error, StackTrace.empty),
        super();

  // Called by the super constructor – we skip real Hive and set fake state.
  @override
  Future<void> initHive() async {
    if (_overrideState != null) state = _overrideState!;
    // If null, the super already set AsyncValue.loading() – nothing to do.
  }

  // --- Override all Hive-touching mutators to use in-memory state --------

  @override
  void addTodo(String title) {
    final todos = List<Todo>.from(state.value ?? []);
    todos.add(Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    ));
    state = AsyncValue.data(todos);
  }

  @override
  void toggleTodo(String id) {
    final todos = (state.value ?? []).map((t) {
      if (t.id == id) t.isCompleted = !t.isCompleted;
      return t;
    }).toList();
    state = AsyncValue.data(todos);
  }

  @override
  void deleteTodo(String id) {
    final todos =
        (state.value ?? []).where((t) => t.id != id).toList();
    state = AsyncValue.data(todos);
  }
}

// ---------------------------------------------------------------------------
// Helper that wraps TodoScreen with the overridden provider.
// ---------------------------------------------------------------------------
Widget buildApp(FakeTodoNotifier notifier) {
  return ProviderScope(
    overrides: [todoProvider.overrideWith((_) => notifier)],
    child: const MaterialApp(home: TodoScreen()),
  );
}

// ===========================================================================
// Tests
// ===========================================================================
void main() {
  group('TodoScreen widget tests', () {
    testWidgets('1. shows empty-state text when there are no todos',
        (tester) async {
      await tester.pumpWidget(buildApp(FakeTodoNotifier([])));
      await tester.pump();

      expect(find.text('No tasks'), findsOneWidget);
    });

    testWidgets('2. shows CircularProgressIndicator while loading',
        (tester) async {
      await tester.pumpWidget(buildApp(FakeTodoNotifier.loading()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('3. shows error message when provider is in error state',
        (tester) async {
      await tester
          .pumpWidget(buildApp(FakeTodoNotifier.withError('Storage unavailable')));
      await tester.pump();

      expect(find.textContaining('Storage unavailable'), findsOneWidget);
    });

    testWidgets('4. renders a tile for each todo in the list', (tester) async {
      final todos = [
        Todo(id: '1', title: 'Task Alpha'),
        Todo(id: '2', title: 'Task Beta'),
      ];
      await tester.pumpWidget(buildApp(FakeTodoNotifier(todos)));
      await tester.pump();

      expect(find.text('Task Alpha'), findsOneWidget);
      expect(find.text('Task Beta'), findsOneWidget);
    });

    testWidgets('5. completed todo text is styled with line-through',
        (tester) async {
      final todo = Todo(id: '3', title: 'Done task')..isCompleted = true;
      await tester.pumpWidget(buildApp(FakeTodoNotifier([todo])));
      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('Done task'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('6. FAB is present and tapping it opens the add-task dialog',
        (tester) async {
      await tester.pumpWidget(buildApp(FakeTodoNotifier([])));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('New Task'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('7. crash-report button is visible in the app bar',
        (tester) async {
      await tester.pumpWidget(buildApp(FakeTodoNotifier([])));
      await tester.pump();

      expect(find.byKey(const Key('crash_report_button')), findsOneWidget);
    });
  });
}
