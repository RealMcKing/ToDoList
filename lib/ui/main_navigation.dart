import 'package:flutter/material.dart';
import 'package:todolist/ui/widgets/group_form/group_form_widget.dart';
import 'package:todolist/ui/widgets/groups/groups_widget.dart';
import 'package:todolist/ui/widgets/tasks/tasks_widget.dart';
import 'package:todolist/ui/widgets/tasks_form/task_form_widget.dart';

abstract class MainNavigationRouteNames {
  static const group = '/';
  static const groupForm = '/formGroup';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/formTask';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.group;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.group: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TasksWidget(configuration: configuration));
      case MainNavigationRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TaskFormWidget(groupKey: groupKey));
      default:
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
