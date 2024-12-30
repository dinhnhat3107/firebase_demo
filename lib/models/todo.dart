import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String task;
  final bool isDone;
  final Timestamp createdOn;
  final Timestamp updatedOn;
  final String userId;

  Todo({
    required this.task,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
    required this.userId,
  });
  Todo.fromJson(Map<String, Object?> json)
      : this(
          task: json['task'] as String? ?? '',
          isDone: json['isDone'] as bool? ?? false,
          createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
          updatedOn: json['updatedOn'] as Timestamp? ?? Timestamp.now(),
          userId: json['userId'] as String? ?? '',
        );

  Todo copyWith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    String? userId,
  }) {
    return Todo(
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      userId: userId ?? this.userId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'userId': userId,
    };
  }
}
