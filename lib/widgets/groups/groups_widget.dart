import 'package:flutter/material.dart';

class GroupsWidget extends StatelessWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
      ),
      body: const _GroupListWidget(),
    );
  }
}

class _GroupListWidget extends StatefulWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  _GroupListWidgetState createState() => _GroupListWidgetState();
}

class _GroupListWidgetState extends State<_GroupListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return _GroupListRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 3);
      },
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  const _GroupListRowWidget({Key? key, required this.indexInList}) : super(key: key);
  final int indexInList;

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('100'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

