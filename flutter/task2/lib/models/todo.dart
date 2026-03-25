import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  bool isCompleted;

  Todo({
    required this.id, 
    required this.title, 
    this.isCompleted = false,
  });
}