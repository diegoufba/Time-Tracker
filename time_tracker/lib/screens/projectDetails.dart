import 'package:flutter/material.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/screens/taskDetails.dart';
import 'package:time_tracker/screens/taskForm.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  ProjectDetailsScreen({super.key, required this.project});
  final Project project;

  bool editProjectDetails = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(projectsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Projeto ${project.name}"),
              bottom: const TabBar(tabs: [
                Tab(
                  child: Text("Detalhes"),
                ),
                Tab(child: Text("Tarefas"))
              ])),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Expanded(
                  child: TabBarView(children: [
                //--------------------------
                // TAB DE DETALHES DO PROJETO
                //--------------------------
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editProjectDetails,
                              controller:
                                  TextEditingController(text: project.name),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Título',
                              ))),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 115,
                              child: TextField(
                                  readOnly: !editProjectDetails,
                                  controller: TextEditingController(
                                      text: project.price != 0
                                          ? "R\$ ${project.price.toString()}"
                                          : "Nenhum"),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Preço',
                                  ))),
                          const SizedBox(width: 20),
                          SizedBox(
                              width: 115,
                              child: TextField(
                                  readOnly: !editProjectDetails,
                                  controller: TextEditingController(
                                      text: project.hourlyRate
                                          ? "Por horas"
                                          : "Valor fixo"),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Tipo de cobrança',
                                  ))),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                          width: 250,
                          child: TextField(
                              readOnly: !editProjectDetails,
                              controller: TextEditingController(
                                  text: project.deadlineDate != null
                                      ? project.deadlineDate.toString()
                                      : "Sem prazo"),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Data Limite',
                              ))),
                      if (project.finished) ...[
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextField(
                                readOnly: !editProjectDetails,
                                controller: TextEditingController(
                                    text: project.deliveryDate.toString()),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Data Entrega',
                                ))),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextField(
                                readOnly: !editProjectDetails,
                                controller: TextEditingController(
                                    text: project.spentTime != null
                                        ? "${project.spentTime.toString()} horas"
                                        : "Nenhum"),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tempo gasto',
                                ))),
                      ]
                    ],
                  ),
                ),

                //--------------------------
                // TAB DE TAREFAS DO PROJETO
                //--------------------------
                Column(children: [
                  project.tasks.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: project.tasks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title:
                                    Text(project.tasks.elementAt(index).name),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskDetails(
                                            task: project.tasks
                                                .elementAt(index)))));
                          })
                      : const Text("Nenhuma tarefa no projeto"),
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskForm(project: project)))
                          },
                      child: const Text("Criar Tarefa"))
                ]),
              ]))
            ]),
          )),
    );
  }
}
