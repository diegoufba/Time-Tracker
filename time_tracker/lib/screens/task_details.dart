import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/model/task.dart';

class TaskDetails extends ConsumerWidget {
  TaskDetails({super.key, required this.task});
  final Task task;

  bool editTaskDetails = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefa ${task.name}"),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 30),
          SizedBox(
              width: 250,
              child: TextField(
                  readOnly: !editTaskDetails,
                  controller: TextEditingController(text: task.name),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ))),
          const SizedBox(height: 30),
          SizedBox(
              width: 250,
              child: TextField(
                  readOnly: !editTaskDetails,
                  controller:
                      TextEditingController(text: task.getInitialDateAsText()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Início',
                  ))),
          const SizedBox(height: 30),
          SizedBox(
              width: 250,
              child: TextField(
                  readOnly: !editTaskDetails,
                  controller: TextEditingController(text: task.getFinalDateAsText()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prazo',
                  ))),
          const SizedBox(height: 30),
          SizedBox(
              width: 250,
              child: TextField(
                  readOnly: !editTaskDetails,
                  controller: TextEditingController(text: task.getHourAsText()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tempo gasto',
                  ))),
          const SizedBox(height: 30),
          SizedBox(
              width: 250,
              child: TextField(
                  readOnly: !editTaskDetails,
                  controller: TextEditingController(text: task.isCompleted? "Completa" : "Incompleta"),
                  style: TextStyle(color: task.isCompleted? Colors.greenAccent[400] : Colors.amber.shade700),
                  decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status',
              ))),
        ],
      )),
    );
  }
}
