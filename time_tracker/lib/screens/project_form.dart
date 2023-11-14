import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';

class ProjectForm extends ConsumerWidget {
  const ProjectForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadlineDateController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String projectName = "";
    double priceProject = 0;
    DateTime? deliveryDateProject ;
    DateTime deadlineDateProject = DateTime.now();
    double estimatedTimeProject = 0;
    bool projectHourlyRated = false;
    List<String> chargeOptions = ["Valor fixo", "Por hora"];
    DateTime timeNow = DateTime.now();

    return Scaffold(
        appBar: AppBar(title: const Text('Cadastrar Projeto')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Nome do projeto',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite um nome';
                    }
                    projectName = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Preço do Projeto',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite um preço';
                    }
                    double? aux = double.tryParse(value);
                    if (aux == null || aux < 0) {
                      return 'Por favor, digite um preço válido';
                    }
                    priceProject = aux;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Tempo estimado (em horas)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite um tempo ';
                    }
                    double? aux = double.tryParse(value);
                    if (aux == null || aux <= 0) {
                      return 'Por favor, digite um tempo válido';
                    }
                    estimatedTimeProject = aux;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownMenu(
                    initialSelection: chargeOptions.first,
                    label: const Text("Tipo de cobrança"),
                    onSelected: (value) => {
                          value == "Por hora"
                              ? projectHourlyRated = true
                              : projectHourlyRated = false
                        },
                    dropdownMenuEntries: chargeOptions
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList()),
                const SizedBox(height: 20),
                TextFormField(
                  controller: deadlineDateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prazo',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o prazo';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: timeNow,
                        firstDate: timeNow,
                        cancelText: "Cancelar",
                        helpText: "Escolha o prazo",
                        errorFormatText: "Formato inválido",
                        errorInvalidText: "Texto inválido",
                        locale: const Locale('pt', 'BR'),
                        lastDate: DateTime(timeNow.year + 10));
                    if (newDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(newDate);
                      deadlineDateProject = newDate;
                      deadlineDateController.text = formattedDate;
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
                          final List<Project> projetosDeepCopy = List.from(
                              ref.read(projectsProvider.notifier).state);
                          Project newProject = Project(
                              projectName,
                              priceProject,
                              deliveryDateProject,
                              deadlineDateProject,
                              null,
                              estimatedTimeProject,
                              false,
                              projectHourlyRated,
                              null);
                          projetosDeepCopy.add(newProject);
                          ref.read(projectsProvider.notifier).state =
                              projetosDeepCopy;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Projeto adicionado'),
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
        ));
  }
}
