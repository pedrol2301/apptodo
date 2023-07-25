import 'package:apptodo/models/todo.dart';
import 'package:apptodo/pages/todo_list_item.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];

  void addTodo(String text){
    if(text != ''){
      Todo newTodo = Todo(title: text, datetime: DateTime.now());
      todos.add(newTodo);
      todoController.clear();
    }
  }

  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
  }

  void deleteTodo(Todo todo){
    setState(() {
      todos.remove(todo);
    });
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
                            labelText: "Adicione uma Tarefa",
                            hintText: "Estudar",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        setState(() {
                          addTodo(text);
                        });
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
                      for(Todo todo in todos)
                        TodoListItem(
                            todo: todo,
                            deleteTodo:deleteTodo
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Text('Você possui ${todos.length} tarefas pendentes!')),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: deleteAllTodos,
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
