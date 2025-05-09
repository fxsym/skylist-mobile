import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  void setTodos(List<TodoModel> todoList) {
    _todos = todoList;
    notifyListeners();
  }

  void clearTodos() {
    _todos = [];
    notifyListeners();
  }
}
