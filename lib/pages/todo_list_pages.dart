import 'package:apptodo/models/todo.dart';
import 'package:apptodo/pages/todo_list_item.dart';
import 'package:apptodo/repositories/todo_repository.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];
  List<Todo> finishedTodos = [];

  String? errText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    }).catchError((e) {
      todos = [];
    });
  }

  void addTodo(String text) {
    if (text.isNotEmpty) {
      errText = null;
      setState(() {
        Todo newTodo = Todo(title: text, datetime: DateTime.now());
        todos.add(newTodo);
      });
      todoController.clear();
      todoRepository.saveTodoList(todos);
    }else{
      setState(() {
        errText = 'O titulo não pode ser vazio!';
      });
    }
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  void finishTodo(Todo todo){
    int position = todos.indexOf(todo);
    todo.finished = true;
    setState(() {
      todos.remove(todo);
      todos.insert(position, todo);
    });
    todoRepository.saveTodoList(todos);

  }

  void deleteTodo(Todo todo) {
    int position = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tafera ${todo.title} removida!",
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          backgroundColor: Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(position, todo);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
    todoRepository.saveTodoList(todos);
  }

  void showDialogDeleteAllTodos() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              content: Text("Deseja realmente limpar tudo?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xff00d7f3),
                  ),
                  child: Text(
                    "Cancelar",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(
                    "Limpar",
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          //String text = todoController.text;
                          setState(() {
                            addTodo(value);
                          });
                        },
                        controller: todoController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2
                            )
                          ),
                          labelText: "Adicione uma Tarefa",
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3)
                          ),
                          hintText: "Estudar",
                          border: OutlineInputBorder(),
                          errorText: errText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        addTodo(text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, deleteTodo: deleteTodo,finishTodo:finishTodo),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${todos.length} tarefas pendentes!')),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed:
                          todos.isNotEmpty ? showDialogDeleteAllTodos : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text('Limpar tudo'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
