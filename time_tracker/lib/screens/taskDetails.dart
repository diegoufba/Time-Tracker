import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/model/task.dart';

class TaskDetails extends ConsumerWidget {

  const TaskDetails({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tarefa ${task.name}")
        ),
    );
  }

}