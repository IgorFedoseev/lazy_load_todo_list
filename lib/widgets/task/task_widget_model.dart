import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';
import 'package:lazyload_todo_list/domain/entity/task.dart';

class TaskWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupBox;

  List<Task> _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  Group? _group;
  Group? get group => _group;

  TaskWidgetModel({required this.groupKey}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void _loadGroup() async{
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks(){
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void _setupListenTasks() async{
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void deleteTask(int groupIndex) {
    _group?.tasks?.deleteFromHive(groupIndex);
  }

  void _setup() async{
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox<Group>('groups_box');
    _loadGroup();
    _setupListenTasks();
  }
}

class TaskWidgetModelProvider extends InheritedNotifier {
  final TaskWidgetModel model;
  const TaskWidgetModelProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, notifier: model, child: child);

  static TaskWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetModelProvider>()
        ?.widget;
    return widget is TaskWidgetModelProvider ? widget : null;
  }
}
