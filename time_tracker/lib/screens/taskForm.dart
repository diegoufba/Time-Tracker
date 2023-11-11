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
    String taskName = "";
    DateTime? initialDateTask;
    DateTime? finalDateTask;
    DateTime timeNow = DateTime.now();

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
              const SizedBox(height: 20),
              TextFormField(
                controller: intitialDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data inicial',
                ),
                readOnly: true,
                onTap: () async{
                  DateTime? finalDateTime = await pickDateTime(context, timeNow);
                  if(finalDateTime != null){
                     String formattedDate =
                        DateFormat('dd/MM/yyyy hh:mm').format(finalDateTime);
                    initialDateTask = finalDateTime;
                    intitialDateController.text = formattedDate;
                  }
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
                      Task newTask = Task(
                          taskName, initialDateTask, finalDateTask, 0, false);
                      int i = projetosDeepCopy.indexOf(project);
                      projetosDeepCopy.elementAt(i).tasks.add(newTask);
                      ref.read(projectsProvider.notifier).state =
                          projetosDeepCopy;
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


Future<DateTime?> pickDateTime(BuildContext context,DateTime timeNow) async{
   DateTime? newDate = await pickDate(context,timeNow);
   if(newDate == null) return null;

  TimeOfDay? newTime = await pickTime(context,timeNow);
  if(newTime != null){
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

Future<DateTime?> pickDate(BuildContext context,DateTime timeNow) => showDatePicker(
      context: context,
      initialDate: timeNow,
      firstDate: timeNow,
      cancelText: "Cancelar",
      helpText: "Escolha o prazo",
      errorFormatText: "Formato inválido",
      errorInvalidText: "Texto inválido",
      locale: const Locale('pt', 'BR'),
      lastDate: DateTime(timeNow.year + 10)
);

Future<TimeOfDay?> pickTime(BuildContext context,DateTime timeNow) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute),
      cancelText: "Cancelar",
      helpText: "Escolha o prazo",
      errorInvalidText: "Texto inválido",
);

// Future pickDateTime(BuildContext context, DateTime timeNow) async{
//   DateTime? newDate = await showDatePicker(
//       context: context,
//       initialDate: timeNow,
//       firstDate: timeNow,
//       cancelText: "Cancelar",
//       helpText: "Escolha o prazo",
//       errorFormatText: "Formato inválido",
//       errorInvalidText: "Texto inválido",
//       locale: const Locale('pt', 'BR'),
//       lastDate: DateTime(timeNow.year + 10));
//   if(newDate != null){
//     String formattedDate =
//                         DateFormat('dd/MM/yyyy').format(newDate);
//                     initialDateTask = newDate;
//                     intitialDateController.text = formattedDate;
//   }
//   else return;
//   TimeOfDay? newTime = await showDatePicker(
//       context: context,
//       initialDate: timeNow,
//       firstDate: timeNow,
//       cancelText: "Cancelar",
//       helpText: "Escolha o prazo",
//       errorFormatText: "Formato inválido",
//       errorInvalidText: "Texto inválido",
//       locale: const Locale('pt', 'BR'),
//       lastDate: DateTime(timeNow.year + 10));
//    if(newTime != null){
//     final finalDateTime  = DateTime(
//       newDate.year,
//       newDate.month,
//       newDate.day,
//       newDate.hour,
//       newDate.minute,
//     );

//     String formattedDate =
//                         DateFormat('dd/MM/yyyy hh:mm').format(finalDateTime);
//                     initialDateTask = finalDateTime;
//                     intitialDateController.text = formattedDate;
//   }
// }
