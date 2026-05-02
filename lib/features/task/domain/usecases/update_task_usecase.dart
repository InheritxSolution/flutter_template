import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> execute(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}
