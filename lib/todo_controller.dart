import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'todo_model.dart';

class ToDoController {
  Future<List<ToDo>> fetchTasks() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..orderByDescending('createdAt');
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((e) => ToDo.fromParse(e)).toList();
    } else {
      return [];
    }
  }

  Future<bool> addTask(String content) async {
    final task = ParseObject('Task')
      ..set('content', content);
    final response = await task.save();
    return response.success;
  }

  Future<bool> deleteTask(String objectId) async {
  final task = ParseObject('Task')
    ..objectId = objectId;
  final response = await task.delete();
  return response.success;
}

  Future<bool> updateTask(String objectId, String content, bool completed) async {
  final task = ParseObject('Task')
    ..objectId = objectId
    ..set('content', content)
    ..set('completed', completed);
  final response = await task.save();
  return response.success;
}
}
