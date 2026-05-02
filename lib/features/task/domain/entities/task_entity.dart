class TaskEntity {
  final int id;
  final String title;
  final bool completed;
  final int userId;

  TaskEntity({
    required this.id,
    required this.title,
    required this.completed,
    required this.userId,
  });

  TaskEntity copyWith({
    int? id,
    String? title,
    bool? completed,
    int? userId,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
