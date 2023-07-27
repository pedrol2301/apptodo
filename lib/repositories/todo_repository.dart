import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {
//TODO: Separate completed todos
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    //print(jsonDecoded);
    return jsonDecoded
        .map((e) => Todo.fromJson(e))
        .toList();
  }


  void saveTodoList(List<Todo> todos){
    final jsonString = json.encode(todos);
    print(jsonString);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}