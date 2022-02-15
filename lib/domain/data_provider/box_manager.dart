import 'package:hive/hive.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';
import 'package:lazyload_todo_list/domain/entity/task.dart';

class BoxManager {
  // Паттерн синглтон:
  static final BoxManager instance = BoxManager._();
  BoxManager._();  // приватный конструктор

  final Map<String, int> _boxCounter = <String, int>{};

  Future<Box<Group>> openGroupBox() async {
    return _openBox<Group>('groups_box', 1, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox<Task>(makeTaskBoxName(groupKey), 2, TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async{
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if(count > 0) return;

    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
