import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/todocon.dart';
import '../model/modelclass.dart';

class TodoScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo'),
        centerTitle: true,
        elevation: 20,
      ),
      body: Obx(() {
        if (controller.todos.isEmpty) {
          return Center(child: Text('No tasks'));
        }
        return ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            Color priorityColor;
            switch (todo.priority) {
              case 1:
                priorityColor = Colors.green[100]!;
                break;
              case 2:
                priorityColor = Colors.green[300]!;
                break;
              case 3:
                priorityColor = Colors.green[500]!;
                break;
              default:
                priorityColor = Colors.white;
            }
            return Card(
              color: priorityColor,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  todo.task,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
                subtitle: Text(todo.isDone ? 'Completed' : 'Not completed'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(todo.isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onPressed: () => controller.todoStatus(todo.id!),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return OpenDialog(todo: todo);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteTodo(todo.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return OpenDialog();
            },
          );
        },
      ),
    );
  }
}

class OpenDialog extends StatefulWidget {
  final Todo? todo;

  OpenDialog({this.todo});

  @override
  _OpenDialogState createState() => _OpenDialogState();
}

class _OpenDialogState extends State<OpenDialog> {
  final _taskController = TextEditingController();
  final _priorityController = TextEditingController();
  final TodoController _todoController = Get.find();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _taskController.text = widget.todo!.task;
      _priorityController.text = widget.todo!.priority.toString();
      _isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _priorityController,
            decoration: InputDecoration(
                labelText: 'Priority (1 = Low, 2 = Medium, 3 = High)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final todo = Todo(
              id: widget.todo?.id,
              task: _taskController.text,
              priority: int.tryParse(_priorityController.text) ?? 1,
              isDone: widget.todo?.isDone ?? false,
            );
            if (_isEditing) {
              _todoController.updateTodo(todo);
            } else {
              _todoController.addTodo(todo);
            }
            Navigator.of(context).pop();
          },
          child: Text(_isEditing ? 'Update' : 'Add'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
