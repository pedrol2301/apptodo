import 'package:apptodo/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.deleteTodo,
    required this.finishTodo,
  });

  final Todo todo;
  final Function(Todo) deleteTodo;
  final Function(Todo) finishTodo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Slidable(
        //TODO implement finish todo
        // startActionPane: ActionPane(
        //   motion: StretchMotion(),
        //   extentRatio: 0.25,
        //   children: [
        //     SlidableAction(
        //         borderRadius: BorderRadius.circular(4),
        //         icon: Icons.check,
        //         label: 'Concluir',
        //         backgroundColor: Colors.green,
        //         foregroundColor: Colors.white,
        //         onPressed: (context){
        //           finishTodo(todo);
        //         })
        //   ],
        // ),
        endActionPane: ActionPane(
          motion: StretchMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(4),
              //deixa o "deletar" com bordas redondas
              onPressed: (context) {
                deleteTodo(todo);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.grey[200]),
          //margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm:ss').format(todo.datetime),
                style: TextStyle(fontSize: 15),
              ),
              Text(
                todo.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
