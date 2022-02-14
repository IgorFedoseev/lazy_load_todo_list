import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';

class GroupFormWidgetModel {
  String groupName = '';

  void saveGroup(BuildContext context) async {
    if(groupName.isEmpty) return;
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  const GroupFormWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, child: child);

  final GroupFormWidgetModel model;

  // static GroupFormWidgetModelProvider? watch(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  // }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}