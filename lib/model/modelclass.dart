class Todo {
  int? id;
  String task;
  int priority;
  bool isDone;

  Todo({
    this.id,
    required this.task,
    required this.priority,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'priority': priority,
      'is_done': isDone ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      task: map['task'],
      priority: map['priority'],
      isDone: map['is_done'] == 1,
    );
  }
}
