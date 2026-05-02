import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/api_exception.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(int id);
  Future<void> updateTask(TaskModel task);
  Future<void> addTask(TaskModel task);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiService _apiService;

  TaskRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await _apiService.get<List<dynamic>>(ApiConstants.todos);
    if (response.success && response.data != null) {
      return response.data!.map((json) => TaskModel.fromJson(json)).toList();
    }
    throw ApiException(message: response.message ?? 'Failed to fetch tasks');
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    final response = await _apiService.get<Map<String, dynamic>>('${ApiConstants.todos}/$id');
    if (response.success && response.data != null) {
      return TaskModel.fromJson(response.data!);
    }
    throw ApiException(message: response.message ?? 'Failed to fetch task');
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '${ApiConstants.todos}/${task.id}',
      data: task.toJson(),
    );
    if (!response.success) {
      throw ApiException(message: response.message ?? 'Failed to update task');
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConstants.todos,
      data: task.toJson(),
    );
    if (!response.success) {
      throw ApiException(message: response.message ?? 'Failed to add task');
    }
  }
}
