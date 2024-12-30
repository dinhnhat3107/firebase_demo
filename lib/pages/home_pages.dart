import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_demo/models/todo.dart';
import 'package:firestore_demo/pages/signin.dart';
import 'package:firestore_demo/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Firestore Demo'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: _signOut,
        ),
      ],
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã đăng xuất")),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [_messageListView()],
      ),
    );
  }

  Widget _messageListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text("Add a todo"),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              String todoId = todos[index].id;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.task),
                  subtitle: Text(
                    DateFormat("dd-mm-yyyy h:mm-a").format(
                      todo.updatedOn.toDate(),
                    ),
                  ),
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) async {
                      Todo updateTodo = todo.copyWith(
                          isDone: !todo.isDone, updatedOn: Timestamp.now());
                      _databaseService.updateTodo(todoId, updateTodo);
                      await FirebaseAnalytics.instance.logEvent(
                        name: "Check Done",
                        parameters: {
                          "task": todo.task,
                          "is_done": updateTodo.isDone,
                          "user_id": updateTodo.userId,
                        },
                      );
                    },
                  ),
                  onLongPress: () async {
                    _databaseService.deleteTodo(todoId);
                    await FirebaseAnalytics.instance.logEvent(
                      name: "Delete Todo",
                      parameters: {
                        "task": todo.task,
                        "user_id": todo.userId,
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayTextInputDialog() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add a todo"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Todo..."),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text("Ok"),
              onPressed: () async {
                Todo todo = Todo(
                  task: _textEditingController.text,
                  isDone: false,
                  createdOn: Timestamp.now(),
                  updatedOn: Timestamp.now(),
                  userId: userId,
                );

                await FirebaseAnalytics.instance.logEvent(
                  name: "add_todo",
                  parameters: {
                    "task": todo.task,
                    "user_id": userId,
                  },
                ).then((_) {
                  debugPrint(
                      "Event 'Add Todo' logged successfully: Task - ${todo.task}");
                });
                _databaseService.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
            )
          ],
        );
      },
    );
  }
}
