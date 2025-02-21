import '../../../core/base/base_repository.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/models/api_exception.dart';
import '../models/todo.dart';

class TodoRepository extends BaseRepository {
  Future<Todo> getTodo(int id) async {
    try {
      final response =
          await get<Map<String, dynamic>>(ApiConstants.todos + id.toString());

      if (response.success) {
        return Todo.fromJson(response.data!);
      }

      throw ApiException(message: response.message ?? 'Failed to fetch todo');
    } on ApiException {
      rethrow;
    }
  }
}
