import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';

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
    DateTime timeNow = DateTime.now();

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
              const SizedBox(height: 20),
              TextFormField(
                controller: intitialDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data inicial',
                ),
                readOnly: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data inicial';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? initialDateTime =
                      await pickDateTime(context, timeNow);
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
                  labelText: 'Data Final',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data final';
                  }
                  if (initialDateTask != null && finalDateTask != null) {
                    if (finalDateTask!.compareTo(initialDateTask!) < 0) {
                      return 'Data final inválida';
                    }
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  DateTime? finalDateTime =
                      await pickDateTime(context, timeNow);
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
                        Task newTask = Task(taskName, initialDateTask!,
                            finalDateTask!, 0, false);
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

Future<DateTime?> pickDateTime(BuildContext context, DateTime timeNow) async {
  DateTime? newDate = await pickDate(context, timeNow);
  if (newDate == null) return null;

  TimeOfDay? newTime = await pickTime(context, timeNow);
  if (newTime != null) {
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );
  }

  return null;
}

Future<DateTime?> pickDate(BuildContext context, DateTime timeNow) =>
    showDatePicker(
        context: context,
        initialDate: timeNow,
        firstDate: timeNow.subtract(const Duration(days: 30)),
        cancelText: "Cancelar",
        errorFormatText: "Formato inválido",
        errorInvalidText: "Texto inválido",
        locale: const Locale('pt', 'BR'),
        lastDate: DateTime(timeNow.year + 10));

Future<TimeOfDay?> pickTime(BuildContext context, DateTime timeNow) =>
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute),
      cancelText: "Cancelar",
      errorInvalidText: "Texto inválido",
    );