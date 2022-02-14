import 'package:hive/hive.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';
import 'package:lazyload_todo_list/domain/entity/task.dart';

class BoxManager {
  // Паттерн синглтон:
  static final BoxManager instance = BoxManager._();
  BoxManager._();  // приватный конструктор

  Future<Box<Group>> openGroupBox() async {
    return _openBox<Group>('groups_box', 1, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox() async {
    return _openBox<Task>('tasks_box', 2, TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async{
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    final box = await Hive.openBox<T>(name);
    return box;
  }
}
