import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> getTaskById(int id);
  Future<void> updateTask(TaskEntity task);
  Future<void> addTask(TaskEntity task);
}
