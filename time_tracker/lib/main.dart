import 'package:flutter/material.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/screens/projects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final projectsProvider = StateProvider((ref) => [
    Project("Projeto A", null, null, null, null, null, null, null, null),
    Project("Projeto B", null, null, null, null, null, null, null, null),
    Project("Projeto C", null, null, null, null, null, null, null, null),
    Project("Projeto D", null, null, null, null, null, null, null, null),
    Project("Projeto E", null, null, null, null, null, null, null, 
      [Task("Taf A", DateTime.now(), DateTime.now(), "12", false), Task("Taf B", DateTime.now(), DateTime.now(), "5", true)]),
]);

class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      title: "Time Tracker",
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Meus Projetos"),
          ),
          body: const ProjectsScreen(),
        ),
    );
  }
}