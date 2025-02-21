import '../../../core/base/base_provider.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

class TodoProvider extends BaseProvider {
  final TodoRepository _repository = TodoRepository();

  Todo? _todo;

  Todo? get todo => _todo;

  Future<void> fetchTodo(int id) async {
    _todo = await callApi(() => _repository.getTodo(id));
  }
}
