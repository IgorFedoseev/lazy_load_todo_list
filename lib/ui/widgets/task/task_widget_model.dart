import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazyload_todo_list/domain/data_provider/box_manager.dart';
import 'package:lazyload_todo_list/domain/entity/task.dart';
import 'package:lazyload_todo_list/ui/navigation/main_navigation.dart';
import 'package:lazyload_todo_list/ui/widgets/task/task_widget.dart';

class TaskWidgetModel extends ChangeNotifier {
  final TaskWidgetConfig config;
  late final Future<Box<Task>> _box;

  List<Task> _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TaskWidgetModel({required this.config}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.taskForm,
      arguments: config.groupKey,
    );
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    await _readTasksFromHive();
    (await _box).listenable().addListener(_readTasksFromHive);
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
