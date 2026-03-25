import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import '../services/crashlytics_service.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoProvider);
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), 
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('crash_report_button'),
            tooltip: 'Simulate Crash Report',
            icon: const Icon(Icons.bug_report_outlined, color: Colors.black54),
            onPressed: () {
              CrashlyticsService.simulateCrash();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Crash report sent (see console)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: switch (todoState) {
        AsyncData(:final value) => value.isEmpty
            ? const _EmptyState()
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return _TodoTile(todo: value[index]);
                },
              ),
        AsyncError(:final error) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddDialog(context, ref, controller),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(
      BuildContext context, WidgetRef ref, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text(
          'New Task',
          style: TextStyle(color: Colors.black87),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
            hintText: 'Enter task...',
            hintStyle: TextStyle(color: Colors.black38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(todoProvider.notifier)
                    .addTodo(controller.text.trim());
                controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  final Todo todo;
  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Checkbox(
          value: todo.isCompleted,
          activeColor: Colors.black,
          checkColor: Colors.white,
          side: const BorderSide(color: Color(0xFFBDBDBD)),
          onChanged: (_) =>
              ref.read(todoProvider.notifier).toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            color: todo.isCompleted
                ? Colors.black38
                : Colors.black87,
            decoration:
                todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.black38),
          onPressed: () =>
              ref.read(todoProvider.notifier).deleteTodo(todo.id),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No tasks',
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
    );
  }
}