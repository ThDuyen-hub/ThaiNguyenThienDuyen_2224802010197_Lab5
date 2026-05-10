import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'login_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() =>
      _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  final api = ApiService();

  List todos = [];

  final titleController =
      TextEditingController();

  void loadTodos() async {

    final data =
        await api.getTodos();

    setState(() {
      todos = data;
    });
  }

  // ADD TODO
  void showAddDialog() {

    titleController.clear();

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(
          title:
              const Text("Add Todo"),

          content: TextField(
            controller: titleController,
            decoration:
                const InputDecoration(
              hintText: "Enter task",
            ),
          ),

          actions: [

            ElevatedButton(
              onPressed: () async {

                await api.addTodo(
                    titleController.text);

                Navigator.pop(context);

                loadTodos();
              },

              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  // UPDATE TODO
  void showEditDialog(
      int id,
      String oldTitle,
      bool isCompleted) {

    titleController.text =
        oldTitle;

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(
          title:
              const Text("Edit Todo"),

          content: TextField(
            controller:
                titleController,
          ),

          actions: [

            ElevatedButton(
              onPressed: () async {

                await api.updateTodo(
                  id,
                  titleController.text,
                  isCompleted,
                );

                Navigator.pop(context);

                loadTodos();
              },

              child: const Text("Update"),
            )
          ],
        );
      },
    );
  }

  // DELETE TODO
  void deleteTodo(int id) async {

    await api.deleteTodo(id);

    loadTodos();
  }

  // LOGOUT
  void logout() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder:
            (_) =>
                const LoginPage(),
      ),

      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();

    loadTodos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Todo App"),

        actions: [

          IconButton(
            onPressed: logout,

            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),

      body: todos.isEmpty
          ? const Center(
              child: Text(
                "No Todo Yet",
              ),
            )
          : ListView.builder(
              itemCount:
                  todos.length,

              itemBuilder:
                  (context, index) {

                final todo =
                    todos[index];

                return Card(
                  margin:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(

                    leading:
                        Checkbox(

                      value:
                          todo[
                              "isCompleted"],

                      onChanged:
                          (value) async {

                        await api
                            .updateTodo(
                          todo["id"],
                          todo["title"],
                          value!,
                        );

                        loadTodos();
                      },
                    ),

                    title:
                        Text(
                      todo["title"],
                    ),

                    trailing:
                        Row(
                      mainAxisSize:
                          MainAxisSize
                              .min,

                      children: [

                        // EDIT
                        IconButton(
                          onPressed: () {

                            showEditDialog(
                              todo["id"],
                              todo[
                                  "title"],
                              todo[
                                  "isCompleted"],
                            );
                          },

                          icon:
                              const Icon(
                            Icons.edit,
                          ),
                        ),

                        // DELETE
                        IconButton(
                          onPressed: () {

                            deleteTodo(
                                todo[
                                    "id"]);
                          },

                          icon:
                              const Icon(
                            Icons.delete,
                            color:
                                Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton:
          FloatingActionButton(

        onPressed:
            showAddDialog,

        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}