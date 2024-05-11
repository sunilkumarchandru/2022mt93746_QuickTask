import 'package:flutter/material.dart';
import 'init_parse.dart';
import 'todo_model.dart';
import 'todo_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initParse();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final ToDoController controller = ToDoController();
  List<ToDo> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    final tasks = await controller.fetchTasks();
    setState(() {
      items = tasks;
      isLoading = false;
    });
  }

  void _addToDo() async {
    final TextEditingController controller = TextEditingController();
    final String? content = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter task description'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (content != null && content.isNotEmpty) {
      setState(() => isLoading = true);
      final success = await this.controller.addTask(content);
      if (success) {
        _loadTasks();  // Reload the list after adding a task
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  void _editTask(ToDo task) async {
    final TextEditingController controller = TextEditingController(text: task.content);
    final String? newContent = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new task description'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newContent != null && newContent.isNotEmpty && newContent != task.content) {
      _updateTask(task.objectId, newContent, task.completed);
    }
  }

  void _updateTask(String objectId, String content, bool completed) async {
    setState(() => isLoading = true);
    final success = await controller.updateTask(objectId, content, completed);
    if (success) {
      _loadTasks();  // Reload the list after updating a task
    } else {
      setState(() => isLoading = false);
    }
  }

  void _deleteTask(String objectId) async {
    setState(() => isLoading = true);
    final success = await controller.deleteTask(objectId);
    if (success) {
      _loadTasks();  // Reload the list after deleting a task
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuickTest"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final task = items[index];
                return ListTile(
                  title: Text(task.content,
                      style: TextStyle(
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                      )),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (bool? value) {
                      _updateTask(task.objectId, task.content, value ?? false);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.objectId),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToDo,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }
}
