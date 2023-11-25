import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/screens/widgets/task_watch.dart';
import 'package:time_tracker/utils.dart';

final taskStatusProvider = StateProvider((ref) => false);
final editTaskDetailsProvider = StateProvider((ref) => false);

class TaskDetails extends ConsumerWidget {
  const TaskDetails({super.key, required this.task, required this.project});
  final Task task;
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(projectsProvider);
    ref.watch(taskStatusProvider);
    ref.watch(editTaskDetailsProvider);
    bool editTaskDetails = ref.read(editTaskDetailsProvider.notifier).state;
    final initialDateController =
        TextEditingController(text: task.getInitialDateAsText());
    final finalDateController = TextEditingController(
        text: task.finalDate != null ? task.getFinalDateAsText() : "");
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void updateTaskTime(Duration spentTime){
      task.addSpentTime(spentTime);
      updateProjectTask(ref,project,task,false);
    }


    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                 onPressed: () {
                    ref.read(editTaskDetailsProvider.notifier).state = false;
                    Navigator.of(context).pop();
                 },
              ),
              title: Text("Tarefa ${task.name}"),
              bottom: const TabBar(tabs: [
                Tab(
                  child: Text("Cronômetro"),
                ),
                Tab(child: Text("Detalhes"))
              ])),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                    child: TabBarView(children: [
                  //--------------------------
                  // TAB DE CRONOMETRO DA TAREFA
                  //--------------------------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      TaskWatch(task: task, project: project,),
                      ],
                  ),

                  //--------------------------
                  // TAB DE DETALHES DA TAREFA
                  //--------------------------
                  Center(
                      child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                readOnly: !editTaskDetails,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe o nome';
                                  }
                                  task.name = value;
                                  return null;
                                },
                                controller:
                                    TextEditingController(text: task.name),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                ))),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                enabled: editTaskDetails,
                                onTap: () async {
                                  DateTime? initialDateTime =
                                      await pickDateTime(context);
                                  if (initialDateTime != null) {
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy hh:mm')
                                            .format(initialDateTime);
                                    task.initialDate = initialDateTime;
                                    initialDateController.text = formattedDate;
                                  }
                                },
                                controller: initialDateController,
                                validator: (String? value) {
                                  if (task.initialDate != null &&
                                      task.finalDate != null) {
                                    if (task.finalDate!
                                            .compareTo(task.initialDate!) <
                                        0) {
                                      return 'Início superior ao prazo';
                                    }
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Início',
                                ))),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                enabled: editTaskDetails,
                                validator: (String? value) {
                                  if (task.finalDate != null &&
                                      task.initialDate != null) {
                                    if (task.finalDate!
                                            .compareTo(task.initialDate!) <
                                        0) {
                                      return 'Prazo inferior ao início';
                                    }
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? initialDateTime =
                                      await pickDateTime(context);
                                  if (initialDateTime != null) {
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy hh:mm')
                                            .format(initialDateTime);
                                    task.finalDate = initialDateTime;
                                    finalDateController.text = formattedDate;
                                  }
                                },
                                controller: finalDateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Prazo',
                                ))),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: task.getHourAsText()),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: editTaskDetails
                                      ? 'Tempo gasto (em horas)'
                                      : 'Tempo gasto',
                                ))),
                        const SizedBox(height: 30),
                        if (!editTaskDetails) ...[
                          SizedBox(
                              width: 250,
                              child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: task.getStatus()),
                                  style: TextStyle(
                                      color:
                                          getTaskStatusColor(task.getStatus())),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Status',
                                  ))),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  task.isCompleted = !task.isCompleted;
                                  updateProjectTask(ref, project, task, false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(task.isCompleted
                                        ? "Tarefa concluída"
                                        : "Tarefa retomada"),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: task.isCompleted
                                        ? Colors.amber.shade700
                                        : Colors.greenAccent[400]),
                                icon: Icon(task.isCompleted
                                    ? Icons.replay
                                    : Icons.check_outlined),
                                label: Text(
                                    task.isCompleted ? "Retomar" : "Concluir"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ref
                                      .read(editTaskDetailsProvider.notifier)
                                      .state = !editTaskDetails;
                                },
                                icon: const Icon(Icons.create_outlined),
                                label: const Text("Editar"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {
                              showAlertDialog(context, ref, task, project);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400]),
                            icon: const Icon(Icons.delete_outlined),
                            label: const Text("Deletar"),
                          ),
                        ],
                        if (editTaskDetails) ...[
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                updateProjectTask(ref, project, task, true);
                              }
                            },
                            icon: const Icon(Icons.check_box_rounded),
                            label: const Text("Concluir edição"),
                          ),
                        ]
                      ],
                    ),
                  ))
                ]))
              ],
            ),
          ),
        ));
  }
}

updateProjectTask(
    WidgetRef ref, Project project, Task task, bool toogleEditMode) {
      print("CALLED");
      print("${task.spentTime!.inSeconds/60} : ${task.spentTime!.inSeconds}");
  final List<Project> projetosDeepCopy =
      List.from(ref.read(projectsProvider.notifier).state);
  int iProject = projetosDeepCopy.indexOf(project);
  int iTask = project.tasks.indexOf(task);
  Project auxProject = projetosDeepCopy[iProject];
  List<Task> auxTaskList = List.from(auxProject.tasks);
  auxTaskList.insert(iTask, task);
  auxTaskList.removeAt(iTask + 1);
  auxProject.tasks = auxTaskList;
  ref.read(projectsProvider.notifier).state[iProject] = auxProject;
  if (toogleEditMode) {
    ref.read(editTaskDetailsProvider.notifier).state =
        !ref.read(editTaskDetailsProvider.notifier).state;
  } else {
    ref.read(taskStatusProvider.notifier).state =
        !ref.read(taskStatusProvider.notifier).state;
  }
}

showAlertDialog(
    BuildContext context, WidgetRef ref, Task task, Project project) {
  // set up the buttons
  Widget cancelButton = IconButton(
    icon: const Icon(Icons.cancel),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = IconButton(
    icon: Icon(Icons.delete_forever, color: Colors.red[400]),
    onPressed: () {
      List<Project> projetosDeepCopy =
          List.from(ref.read(projectsProvider.notifier).state);
      int i = projetosDeepCopy.indexOf(project);
      project.removeTask(task);
      projetosDeepCopy[i] = project;
      ref.read(projectsProvider.notifier).state = projetosDeepCopy;
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tarefa deletada."),
        duration: Duration(milliseconds: 1000),
      ));
    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Confirmação"),
    content: const Text("Deletar tarefa?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
