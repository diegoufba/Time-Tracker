import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/screens/project_details.dart';
import 'package:time_tracker/screens/project_form.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Project> projects = ref.watch(projectsProvider);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: Text(projects.elementAt(index).name),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectDetailsScreen(
                                      project: projects.elementAt(index))));
                        }));
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Total de projetos: ${projects.length}",
              textAlign: TextAlign.left,
            ),
          ),
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
                                builder: (context) => const ProjectForm()))
                      },
                  child: const Text("Adicionar Projeto")),
            ),
          )
        ],
      ),
    );
  }
}
