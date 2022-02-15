import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazyload_todo_list/ui/widgets/task/task_widget_model.dart';

class TaskWidgetConfig {
  final int groupKey;
  final String title;

  TaskWidgetConfig(this.groupKey, this.title);
}

class TaskWidget extends StatefulWidget {
  final TaskWidgetConfig config;
  const TaskWidget({Key? key, required this.config}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TaskWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskWidgetModel(config: widget.config);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     // получаем аргумент из функции showTasks файла widget_group_model
  //     _model = TaskWidgetModel(groupKey: groupKey);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final model = _model;
      return TaskWidgetModelProvider(
        model: model,
        child: const TaskWidgetBody(),
      );
  }
}

class TaskWidgetBody extends StatelessWidget {
  const TaskWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.config.title ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => model?.showForm(context),
      ),
      body: const _TaskListWidget(),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TaskWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemCount: groupsCount,
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 3,
          thickness: 1.5,
        );
      },
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);
  final int indexInList;

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done : Icons.circle_outlined;
    final style = task.isDone ? const TextStyle(decoration: TextDecoration.lineThrough) : null;

    return Slidable(
      // key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (buildContext) => model.deleteTask(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: ListTile(
        title: Text(task.text, style: style),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}