import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_local_data_source.dart';
import '../data_sources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TaskEntity>> getTasks() async {
    try {
      final remoteTasks = await remoteDataSource.getTasks();
      await localDataSource.cacheTasks(remoteTasks);
      // Explicitly convert to List<TaskEntity> to avoid runtime type issues
      return remoteTasks.map((e) => e.toEntity()).toList();
    } catch (e) {
      final localTasks = await localDataSource.getCachedTasks();
      if (localTasks.isNotEmpty) {
        return localTasks.map((e) => e.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    final model = await remoteDataSource.getTaskById(id);
    return model.toEntity();
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await remoteDataSource.updateTask(TaskModel.fromEntity(task));
    
    // Update local cache as well
    final localTasks = await localDataSource.getCachedTasks();
    final index = localTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      localTasks[index] = TaskModel.fromEntity(task);
      await localDataSource.cacheTasks(localTasks);
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await remoteDataSource.addTask(TaskModel.fromEntity(task));
    
    // Update local cache
    final localTasks = await localDataSource.getCachedTasks();
    localTasks.add(TaskModel.fromEntity(task));
    await localDataSource.cacheTasks(localTasks);
  }
}
