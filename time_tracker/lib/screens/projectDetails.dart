import 'package:flutter/material.dart';
import 'package:time_tracker/model/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/screens/taskDetails.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Projeto ${project.name}")),
      body: Column(children: [
        const Text("Tarefas"),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: project.tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(project.tasks.elementAt(index).name),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetails(
                              task: project.tasks.elementAt(index)))));
            })
      ]),
    );
  }
}
