import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazyload_todo_list/domain/data_provider/box_manager.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';
import 'package:lazyload_todo_list/ui/navigation/main_navigation.dart';
import 'package:lazyload_todo_list/ui/widgets/task/task_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;

  List<Group> _groups = <Group>[];
  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if(group != null){
      final config = TaskWidgetConfig(group.key, group.name);
      Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.tasks, arguments: config);
    }
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    (await _box).listenable().addListener(_readGroupsFromHive);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static GroupsWidgetModelProvider? of(BuildContext context) {
    final GroupsWidgetModelProvider? result =
        context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
    return result;
  }

  @override
  bool updateShouldNotify(GroupsWidgetModelProvider oldWidget) {
    return true;
  }
}
