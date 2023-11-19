import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/screens/task_details.dart';
import 'package:time_tracker/screens/task_form.dart';
import 'package:time_tracker/utils.dart';

// final projectChangeProvider = StateProvider((ref) => false);
final editProjectDetailsProvider = StateProvider((ref) => false);

class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(projectsProvider);
    ref.watch(editProjectDetailsProvider);
    bool editProjectDetails =
        ref.read(editProjectDetailsProvider.notifier).state;
    List<String> chargeOptions = ["Valor fixo", "Por hora"];
    final deadlineDateController = TextEditingController(
        text: project.deadlineDate != null
            ? DateFormat('dd/MM/yyyy').format(project.deadlineDate!).toString()
            : "");
    final deliveryDateController = TextEditingController(
        text: project.deliveryDate != null
            ? DateFormat('dd/MM/yyyy').format(project.deliveryDate!).toString()
            : "");
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                 onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(editProjectDetailsProvider.notifier).state = false;
                 },
              ),
              title: Text("Projeto ${project.name}"),
              bottom: const TabBar(tabs: [
                Tab(
                  child: Text("Tarefas"),
                ),
                Tab(child: Text("Detalhes"))
              ])),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Expanded(
                  child: TabBarView(
                children: [
                  //--------------------------
                  // TAB DE TAREFAS DO PROJETO
                  //--------------------------
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(children: [
                      project.tasks.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: project.tasks.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: ListTile(
                                        title: Text(project.tasks
                                            .elementAt(index)
                                            .name),
                                        subtitle: Text(project.tasks.elementAt(index).getStatus(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: getTaskStatusColor(
                                                    project.tasks
                                                        .elementAt(index)
                                                        .getStatus()))),
                                        trailing:
                                            const Icon(Icons.arrow_forward),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TaskDetails(
                                                    project: project,
                                                    task: project.tasks
                                                        .elementAt(index))))));
                              })
                          : const Text("Nenhuma tarefa no projeto"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskForm(project: project)))
                                  },
                              child: const Text("Criar Tarefa")),
                        ),
                      )
                    ]),
                  ),
                  //--------------------------
                  // TAB DE DETALHES DO PROJETO
                  //--------------------------
                  Center(
                    child: Form(
                      key: formKey,
                      child: Column(children: [
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                readOnly: !editProjectDetails,
                                controller:
                                    TextEditingController(text: project.name),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe o título';
                                  }
                                  project.name = value;
                                  return null;
                                },
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
                                child: TextFormField(
                                    readOnly: !editProjectDetails,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite um preço';
                                      }
                                      double? aux = double.tryParse(value);
                                      if (aux == null || aux < 0) {
                                        return 'Por favor, digite um preço válido';
                                      }
                                      project.price = aux;
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: project.price != 0
                                            ? (editProjectDetails
                                                ? project.price.toString()
                                                : "R\$ ${project.price.toString()}")
                                            : "Nenhum"),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Preço',
                                    ))),
                            const SizedBox(width: 20),
                            DropdownMenu(
                                enabled: editProjectDetails,
                                width: 120,
                                initialSelection: project.hourlyRate
                                    ? chargeOptions.last
                                    : chargeOptions.first,
                                label: const Text("Tipo de cobrança"),
                                onSelected: (value) => {
                                      value == "Por hora"
                                          ? project.hourlyRate = true
                                          : project.hourlyRate = false
                                    },
                                dropdownMenuEntries: chargeOptions
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList()),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                                readOnly: !editProjectDetails,
                                controller:
                                    TextEditingController(text: project.estimatedTime != null? project.estimatedTime.toString() : "Indefinido"),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    double? aux = double.tryParse(value);
                                    if (aux == null || aux <= 0) {
                                      return 'Por favor, digite um tempo válido';
                                    }
                                    project.estimatedTime = aux;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: editProjectDetails
                                      ? 'Tempo estimado (em horas)'
                                      : 'Tempo estimado',
                                ))),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: 250,
                            child: TextFormField(
                              enabled: editProjectDetails,
                              controller: deadlineDateController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Prazo',
                              ),
                              readOnly: !editProjectDetails,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe o prazo';
                                }
                                return null;
                              },
                              onTap: () async {
                                DateTime? initialDateTime =
                                    await pickOnlyDate(context);
                                if (initialDateTime != null) {
                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy')
                                          .format(initialDateTime);
                                  project.deadlineDate = initialDateTime;
                                  deadlineDateController.text = formattedDate;
                                }
                              },
                            )),
                        if (project.finished || editProjectDetails) ...[
                          const SizedBox(height: 30),
                          SizedBox(
                              width: 250,
                              child: TextFormField(
                                enabled: editProjectDetails,
                                controller: deliveryDateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Data de entrega',
                                ),
                                readOnly: !editProjectDetails,
                                validator: (String? value) {
                                  if (project.deliveryDate != null) {
                                    if (project.deliveryDate!
                                            .compareTo(project.deadlineDate!) <
                                        0) {
                                      return 'Data de entrega inválida';
                                    }
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? initialDateTime =
                                      await pickOnlyDate(context);
                                  if (initialDateTime != null) {
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(initialDateTime);
                                    project.deliveryDate = initialDateTime;
                                    project.finished = true;
                                    deliveryDateController.text = formattedDate;
                                  } else {
                                    project.finished = false;
                                    project.deliveryDate = null;
                                  }
                                },
                              )),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: 250,
                              child: TextFormField(
                                  readOnly: !editProjectDetails,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      double? aux = double.tryParse(value);
                                      if (aux != null && aux < 0) {
                                        return 'Horas inválidas';
                                      }
                                      project.spentTime = aux ?? 0;
                                    }
                                    project.spentTime = 0;
                                    return null;
                                  },
                                  controller: TextEditingController(
                                      text: project.spentTime != null
                                          ? (editProjectDetails
                                              ? project.spentTime.toString()
                                              : project.spentTimeAsText())
                                          : "Nenhum"),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: editProjectDetails
                                        ? "Tempo gasto (em horas)"
                                        : 'Tempo gasto',
                                  ))),
                        ],
                        const SizedBox(height: 20),
                        if (!editProjectDetails) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  ref
                                      .read(editProjectDetailsProvider.notifier)
                                      .state = !editProjectDetails;
                                },
                                icon: const Icon(Icons.create_outlined),
                                label: const Text("Editar"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showAlertDialog(context, ref, project);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400]),
                                icon: const Icon(Icons.delete_outlined),
                                label: const Text("Deletar"),
                              ),
                            ],
                          ),
                        ],
                        if (editProjectDetails) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                int i = ref
                                    .read(projectsProvider.notifier)
                                    .state
                                    .indexOf(project);
                                ref.read(projectsProvider.notifier).state[i] =
                                    project;
                                ref
                                    .read(editProjectDetailsProvider.notifier)
                                    .state = !editProjectDetails;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Projeto editado'),
                                        duration:
                                            Duration(milliseconds: 1600)));
                              }
                            },
                            icon: const Icon(Icons.create_outlined),
                            label: const Text("Concluir edição"),
                          ),
                        ]
                      ]),
                    ),
                  ),
                ],
              ))
            ]),
          )),
    );
  }

  showAlertDialog(BuildContext context, WidgetRef ref, Project project) {
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
        int i = ref.read(projectsProvider.notifier).state.indexOf(project);
        ref.read(projectsProvider.notifier).state[i] = project;
        final List<Project> projetosDeepCopy =
            List.from(ref.read(projectsProvider.notifier).state);
        projetosDeepCopy.removeAt(i);
        ref.read(projectsProvider.notifier).state = projetosDeepCopy;
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Projeto deletado."),
          duration: Duration(milliseconds: 1000),
        ));
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmação"),
      content: const Text("Deletar projeto?"),
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
}
