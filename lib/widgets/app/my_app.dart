import 'package:flutter/material.dart';
import 'package:todolist/widgets/group_form/group_form_widget.dart';
import 'package:todolist/widgets/groups/groups_widget.dart';
import 'package:todolist/widgets/tasks/tasks_widget.dart';
import 'package:todolist/widgets/tasks_form/task_form_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
        '/groups/tasks': (context) => const TasksWidget(),
        '/groups/tasks/form': (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
    );
  }
}
