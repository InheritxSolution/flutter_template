import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> execute(TaskEntity task) async {
    return await repository.addTask(task);
  }
}
