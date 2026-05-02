import '../../../../core/base/base_provider.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';

class TaskProvider extends BaseProvider {
  final GetTasksUseCase getTasksUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final AddTaskUseCase addTaskUseCase;

  TaskProvider({
    required this.getTasksUseCase,
    required this.updateTaskUseCase,
    required this.addTaskUseCase,
  });

  List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final result = await callApi(() => getTasksUseCase.execute());
    if (result != null) {
      _tasks = result;
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(TaskEntity task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    
    // Optimistic Update
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }

    try {
      await updateTaskUseCase.execute(updatedTask);
    } catch (e) {
      // Revert on error
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
      setError('Failed to update task status');
    }
  }

  Future<void> addTask(String title) async {
    final newTask = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: false,
      userId: 1,
    );

    // Optimistic Update
    _tasks.insert(0, newTask);
    notifyListeners();

    try {
      await addTaskUseCase.execute(newTask);
    } catch (e) {
      // Revert on error
      _tasks.removeWhere((t) => t.id == newTask.id);
      notifyListeners();
      setError('Failed to add task');
    }
  }
}
