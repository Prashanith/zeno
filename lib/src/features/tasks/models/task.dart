class Task {
  String id = '';
  final String title;
  final String description;
  final List<String> todos;
  DateTime? scheduledAt;
  bool isDaily;

  Task({
    required this.title,
    required this.description,
    required this.todos,
    required this.scheduledAt,
    required this.isDaily
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    var id = data['id'].toString() ?? '';
    var task = Task(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      scheduledAt: DateTime.tryParse(data['scheduledAt'] ?? ''),
      todos: [],
      isDaily: data['isDaily'],
    );
    task.id = id;
    return task;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'todos': todos,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'isDaily': isDaily
    };
  }
}
