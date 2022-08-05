import 'package:flutter/material.dart';
import 'package:todolist/widgets/tasks_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({Key? key}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskFormWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        model: _model!, child: const _TextFormWidgetBody());
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New task'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _TaskTextWidget()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TaskFormWidgetModelProvider.read(context)?.model.saveTasks(context),
        child: (const Icon(Icons.done_rounded)),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextFormField(
      autofocus: true,
      expands: true,
      minLines: null,
      maxLines: null,
      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Text task'),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTasks(context),
    );
  }
}
