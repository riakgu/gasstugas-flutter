class Task {
  final int id;
  final int userId;
  final int categoryId;
  final String taskName;
  final String description;
  final String deadline;
  final String status;

  Task({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.taskName,
    required this.description,
    required this.deadline,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      taskName: json['task_name'],
      description: json['description'],
      deadline: json['deadline'],
      status: json['status'],
    );
  }
}
