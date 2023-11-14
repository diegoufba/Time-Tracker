import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/model/task.dart';

final taskChangeProvider = StateProvider((ref) => false);
final editTaskDetailsProvider = StateProvider((ref) => false);

class TaskDetails extends ConsumerWidget {
  const TaskDetails({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(taskChangeProvider);
    ref.watch(editTaskDetailsProvider);
    bool editTaskDetails = ref.read(editTaskDetailsProvider.notifier).state;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tarefa ${task.name}"),
            bottom: const TabBar(tabs: [
                Tab(
                  child: Text("Cronômetro"),
                ),
                Tab(child: Text("Detalhes"))
              ])
          ),
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
                  Center(
                      child: Column(children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Cronometrar da tarefa iniciado."),
                          duration: Duration(milliseconds: 500),
                        ));
                      },
                      icon: const Icon(Icons.access_alarm),
                      label: const Text("Cronômetro da tarefa"),
                    ),
                  ])),

                  //--------------------------
                  // TAB DE DETALHES DA TAREFA
                  //--------------------------
                  Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editTaskDetails,
                              controller:
                                  TextEditingController(text: task.name),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nome',
                              ))),
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editTaskDetails,
                              controller: TextEditingController(
                                  text: task.getInitialDateAsText()),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Início',
                              ))),
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editTaskDetails,
                              controller: TextEditingController(
                                  text: task.getFinalDateAsText()),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Prazo',
                              ))),
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editTaskDetails,
                              controller: TextEditingController(
                                  text: task.getHourAsText()),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: editTaskDetails
                                    ? 'Tempo gasto (em horas)'
                                    : 'Tempo gasto',
                              ))),
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editTaskDetails,
                              controller: TextEditingController(
                                  text: task.isCompleted
                                      ? "Completa"
                                      : "Incompleta"),
                              style: TextStyle(
                                  color: task.isCompleted
                                      ? Colors.greenAccent[400]
                                      : Colors.amber.shade700),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Status',
                              ))),
                      const SizedBox(height: 30),
                      if (!editTaskDetails) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                task.isCompleted = !task.isCompleted;
                                ref.read(taskChangeProvider.notifier).state =
                                    !ref
                                        .read(taskChangeProvider.notifier)
                                        .state;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(task.isCompleted
                                      ? "Tarefa concluída"
                                      : "Tarefa retomada"),
                                  duration: const Duration(milliseconds: 1500),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Tarefa deletada."),
                              duration: Duration(milliseconds: 500),
                            ));
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
                            ref.read(editTaskDetailsProvider.notifier).state =
                                !editTaskDetails;
                          },
                          icon: const Icon(Icons.check_box_rounded),
                          label: const Text("Concluir edição"),
                        ),
                      ]
                    ],
                  ))
                ]))
              ],
            ),
          ),
        ));
  }
}
