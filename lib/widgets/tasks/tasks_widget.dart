import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TasksWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TasksWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
        model: _model!, child: const _TasksWidgetBody());
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? 'Tasks';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(indexInList: index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: groupsCount);
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done_rounded : null;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

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
            onPressed: (context) => model.deleteTask(indexInList),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}
