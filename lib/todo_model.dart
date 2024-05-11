import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ToDo {
  final String objectId;
  final String content;
  bool completed;

  ToDo({required this.objectId, required this.content, this.completed = false});

  factory ToDo.fromParse(ParseObject parseObject) {
    return ToDo(
      objectId: parseObject.objectId ?? '',
      content: parseObject.get<String>('content') ?? '',
      completed: parseObject.get<bool>('completed') ?? false,
    );
  }
}

