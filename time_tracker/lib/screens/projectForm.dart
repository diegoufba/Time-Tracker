import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';

class ProjectForm extends ConsumerWidget {
  const ProjectForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String projectName = "";
    double priceProject = 0;
    DateTime deliveryDateProject = DateTime.now();
    DateTime deadlineDateProject = DateTime.now();
    double estimatedTimeProject = 0;
    bool projectHourlyRated = false;
    List<String> chargeOptions = ["Valor fixo", "Por hora"];

    //  final List<Project> projects = ref.watch(projectsProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Cadastrar Projeto')),
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Digite o nome do seu Projeto',
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
                  hintText: 'Digite o preço do seu Projeto',
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
              const SizedBox(height: 20),
              DropdownMenu(
                  initialSelection: chargeOptions.first,
                  label: Text("Tipo de cobrança"),
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
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Digite o tempo estimado do seu Projeto',
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
              InputDatePickerFormField(
                errorFormatText: "Digite um formato válido",
                errorInvalidText: "Digie uma data entre 2019 e 2025",
                fieldHintText: "Escreva uma data no formato mm/dd/yyyy",
                fieldLabelText: "Escreva uma data no formato mm/dd/yyyy",
                firstDate: DateTime(DateTime.now().year - 1000),
                lastDate: DateTime(DateTime.now().year + 1000),
                initialDate: deliveryDateProject,
                onDateSubmitted: (date) {
                  deliveryDateProject = date;
                },
              ),
              InputDatePickerFormField(
                errorFormatText: "Digite um formato válido",
                errorInvalidText: "Digie uma data entre 2019 e 2025",
                fieldHintText: "Escreva uma data no formato mm/dd/yyyy",
                fieldLabelText: "Escreva uma data no formato mm/dd/yyyy",
                firstDate: DateTime(DateTime.now().year - 1000),
                lastDate: DateTime(DateTime.now().year + 1000),
                initialDate: deadlineDateProject,
                onDateSubmitted: (date) {
                  deadlineDateProject = date;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final List<Project> projetosDeepCopy =
                          List.from(ref.read(projectsProvider.notifier).state);
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Projeto adicionado'),
                          duration: Duration(milliseconds: 1600)));
                    }
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ));
  }
}
