import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_demo/models/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  late final CollectionReference<Todo> _todosRef;

  DatabaseService() {
    if (userId == null) {
      throw Exception("User is not logged in.");
    }
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
          fromFirestore: (snapshots, _) {
            final data = snapshots.data();
            if (data == null) {
              throw Exception("Document data is null.");
            }
            return Todo.fromJson(data);
          },
          toFirestore: (todo, _) => todo.toJson(),
        );
  }
  Stream<QuerySnapshot<Todo>> getTodos() {
    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    return _todosRef.where('userId', isEqualTo: userId).snapshots();
  }

  void addTodo(Todo todo) {
    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    final todoWithUserId = todo.copyWith(userId: userId);
    _todosRef.add(todoWithUserId);
  }

  void updateTodo(String todoId, Todo todo) {
    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    final updatedTodo = todo.copyWith(userId: userId);
    _todosRef.doc(todoId).update(updatedTodo.toJson());
  }

  void deleteTodo(String todoId) {
    if (userId == null) {
      throw Exception("User is not logged in.");
    }
    _todosRef.doc(todoId).delete();
  }
}
