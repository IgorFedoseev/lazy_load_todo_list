import 'package:flutter/material.dart';
import 'package:lazyload_todo_list/domain/data_provider/box_manager.dart';
import 'package:lazyload_todo_list/domain/entity/group.dart';

class GroupFormWidgetModel {
  String groupName = '';

  void saveGroup(BuildContext context) async {
    if(groupName.isEmpty) return;
    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.of(context).pop();
    await BoxManager.instance.closeBox(box);
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
