import 'package:flutter/material.dart';
import 'package:lazyload_todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:lazyload_todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:lazyload_todo_list/ui/widgets/task/task_widget.dart';
import 'package:lazyload_todo_list/ui/widgets/task_form/task_form_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupForm = '/form';
  static const tasks = '/tasks';
  static const taskForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupForm: (context) => const GroupFormWidget(),
    // MainNavigationRouteNames.tasks: (context) => const TaskWidget(),
    // MainNavigationRouteNames.taskForm: (context) => const TaskFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final config = settings.arguments as TaskWidgetConfig;
        return MaterialPageRoute(
          builder: (context) => TaskWidget(config: config),
        );
      case MainNavigationRouteNames.taskForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupKey: groupKey),
        );
      default:
        const widget = Text('Ошибка навигации!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
