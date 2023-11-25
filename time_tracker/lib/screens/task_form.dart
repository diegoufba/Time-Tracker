import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/utils.dart';

class TaskForm extends ConsumerWidget {
  const TaskForm({super.key, required this.project});
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final intitialDateController = TextEditingController();
    final finalDateController = TextEditingController();
    String taskName = "";
    DateTime? initialDateTask;
    DateTime? finalDateTask;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Tarefa')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nome da Tarefa *',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite um nome';
                  }
                  taskName = value;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: intitialDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data de início',
                ),
                readOnly: true,
                validator: (String? value) {
                  return null;
                },
                onTap: () async {
                  DateTime? initialDateTime =
                      await pickDateTime(context);
                  if (initialDateTime != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy hh:mm').format(initialDateTime);
                    initialDateTask = initialDateTime;
                    intitialDateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: finalDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prazo',
                ),
                validator: (String? value) {
                  if (initialDateTask != null && finalDateTask != null) {
                    if (finalDateTask!.compareTo(initialDateTask!) < 0) {
                      return 'Prazo inválido';
                    }
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  DateTime? finalDateTime =
                      await pickDateTime(context);
                  if (finalDateTime != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy hh:mm').format(finalDateTime);
                    finalDateTask = finalDateTime;
                    finalDateController.text = formattedDate;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        List<Project> projetosDeepCopy = List.from(
                            ref.read(projectsProvider.notifier).state);
                        Task newTask = Task(taskName, initialDateTask,
                            finalDateTask, Duration(), false);
                        int i = projetosDeepCopy.indexOf(project);
                        projetosDeepCopy.elementAt(i).addTask(newTask);
                        ref.read(projectsProvider.notifier).state =
                            projetosDeepCopy;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tarefa adicionada'),
                                duration: Duration(milliseconds: 1600)));
                      }
                    },
                    child: const Text('Cadastrar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}