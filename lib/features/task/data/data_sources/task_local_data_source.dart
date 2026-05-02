import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getCachedTasks();
  Future<void> clearCache();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _taskBoxKey = 'tasks_box';
  static const String _tasksKey = 'cached_tasks';

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await Hive.openBox(_taskBoxKey);
    final tasksJson = tasks.map((t) => t.toJson()).toList();
    await box.put(_tasksKey, jsonEncode(tasksJson));
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final box = await Hive.openBox(_taskBoxKey);
    final tasksString = box.get(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> decoded = jsonDecode(tasksString);
      return decoded.map((json) => TaskModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox(_taskBoxKey);
    await box.delete(_tasksKey);
  }
}
