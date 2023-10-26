import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskmaker/data/todo.dart';
import 'package:taskmaker/todo_bloc/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // add todo
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  // remove todo
  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  // alter todo
  alterTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();
                return AlertDialog(
                  title: Text('Add a Task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Task Title..',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: controller2,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Task description..',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextButton(
                        onPressed: () {
                          addTodo(
                            Todo(
                                title: controller1.text,
                                subtitle: controller2.text),
                          );

                          controller1.text = '';
                          controller2.text = '';
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(Icons.check, color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'Taskmaker',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state.status == TodoStatus.success) {
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              removeTodo(state.todos[i]);
                            },
                            backgroundColor: Color.fromARGB(255, 154, 10, 0),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(state.todos[i].title),
                        subtitle: Text(state.todos[i].subtitle),
                        trailing: Checkbox(
                            value: state.todos[i].isDone,
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            onChanged: (value) {
                              alterTodo(i);
                            }),
                      ),
                    ),
                  );
                });
          } else if (state.status == TodoStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
