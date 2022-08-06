import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupWidgetModelProvider(
        model: _model, child: const _GroupWidgetBody());
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupWidgetModelProvider.read(context)?.model.showForm(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _GroupListRowWidget(indexInList: index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: groupsCount);
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;

  const _GroupListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            backgroundColor: Colors.redAccent,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) => model.deleteGroup(indexInList),
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: () => model.showTasks(context, indexInList),
      ),
    );
  }
}
