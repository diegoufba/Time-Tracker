import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';

class TaskForm extends ConsumerWidget {
  const TaskForm({super.key, required this.project});
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String taskName = "";
    DateTime? initialDateTask;
    DateTime? finalDateTask;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cadastrar Tarefa')),
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Digite o nome da sua Tarefa',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite um nome';
                  }
                  taskName = value;
                  return null;
                },
              ),
              InputDatePickerFormField(
                errorFormatText: "Digite um formato válido",
                errorInvalidText: "Digite uma data entre 2019 e 2025",
                fieldHintText:
                    "Escreva uma data inicial para a tarefa no formato mm/dd/yyyy",
                fieldLabelText:
                    "Escreva uma data inicial para a tarefa no formato mm/dd/yyyy",
                firstDate: DateTime(DateTime.now().year - 1000),
                lastDate: DateTime(DateTime.now().year + 1000),
                initialDate: initialDateTask,
                onDateSubmitted: (date) {
                    initialDateTask = date;
                },
              ),
              InputDatePickerFormField(
                errorFormatText: "Digite um formato válido",
                errorInvalidText: "Digie uma data entre 1500 e 3800",
                fieldHintText:
                    "Escreva uma data final para a tarefa no formato mm/dd/yyyy",
                fieldLabelText:
                    "Escreva uma data final para a tarefa no formato mm/dd/yyyy",
                firstDate: DateTime(DateTime.now().year - 1000),
                lastDate: DateTime(DateTime.now().year + 1000),
                initialDate: finalDateTask,
                onDateSubmitted: (date) {
                    finalDateTask = date;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final List<Project> projetosDeepCopy =
                          List.from(ref.read(projectsProvider.notifier).state);
                      Task newTask = Task(taskName,initialDateTask, finalDateTask, 0, false);
                      int i = projetosDeepCopy.indexOf(project);
                      projetosDeepCopy.elementAt(i).tasks.add(newTask);
                      ref.read(projectsProvider.notifier).state = projetosDeepCopy;
                       Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Tarefa adicionada'),
                          duration: Duration(milliseconds: 1600)));
                    }
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
