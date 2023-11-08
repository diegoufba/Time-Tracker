import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/screens/projectDetails.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Project> projects = ref.watch(projectsProvider);

    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Center(child: Text(projects.elementAt(index).name)),
                  onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectDetailsScreen(
                                    project: projects.elementAt(index))));
                      });
            }),
        Text("Total de projetos: ${projects.length}"),
        ElevatedButton(
            onPressed: () {
              projects.add(Project("Projeto Adicionado", null, null, null, null,
                  null, null, null, null));
              final List<Project> projetosDeepCopy = List.from(projects);
              ref.read(projectsProvider.notifier).state = projetosDeepCopy;
            },
            child: const Text("Adicionar Projeto"))
      ],
    );
  }
}
