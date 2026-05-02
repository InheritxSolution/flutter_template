import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.completed,
    required super.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': userId,
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      completed: completed,
      userId: userId,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      completed: entity.completed,
      userId: entity.userId,
    );
  }
}
