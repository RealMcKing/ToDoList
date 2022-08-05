import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todolist/domain/entity/group.dart';
import 'package:todolist/domain/entity/task.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void deleteGroup(int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('group_box');
    box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupIndex);
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void showTasks(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('group_box');
    final groupKey = box.keyAt(groupIndex) as int;
    unawaited(
        Navigator.of(context).pushNamed('/groups/tasks', arguments: groupKey));
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('group_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('task_box');
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }
}

class GroupWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static GroupWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupWidgetModelProvider>();
  }

  static GroupWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupWidgetModelProvider>()
        ?.widget;
    return widget is GroupWidgetModelProvider ? widget : null;
  }
}
