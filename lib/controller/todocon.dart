import 'package:get/get.dart';
import '../model/modelclass.dart';
import 'dbclass.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final DataBase dbHelper = DataBase();
  @override
  void onInit() {
    fetchTodos();
    super.onInit();
  }

  void fetchTodos() async {
    final taskMaps = await dbHelper.getTasks();
    todos.value = taskMaps.map((map) => Todo.fromMap(map)).toList();
  }

  void addTodo(Todo todo) async {
    await dbHelper.insertTask(todo.toMap());
    fetchTodos();
  }

  void updateTodo(Todo todo) async {
    await dbHelper.updateTask(todo.toMap());
    fetchTodos();
  }

  void deleteTodo(int id) async {
    await dbHelper.deleteTask(id);
    fetchTodos();
  }

  void todoStatus(int id) async {
    var todo = todos.firstWhere((t) => t.id == id);
    todo.isDone = !todo.isDone;
    await dbHelper.updateTask(todo.toMap());
    fetchTodos();
  }
}
