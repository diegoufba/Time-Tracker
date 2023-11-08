import 'package:flutter/material.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/screens/projects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final projectsProvider = StateProvider((ref) => [
    Project("Projeto A", null, null, null, null, null, null, null, null),
    Project("Projeto B", null, null, null, null, null, null, null, null),
    Project("Projeto C", null, null, null, null, null, null, null, null),
    Project("Projeto D", null, null, null, null, null, null, null, null),
    Project("Projeto E", null, null, null, null, null, null, null, null),
]);

class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const appBarTitle = 'Cadastrar Projeto';
    return MaterialApp(
      title: "Time Tracker",
      home: Scaffold(
          appBar: AppBar(
            title: const Text(appBarTitle),
          ),
          body: const ProjectsScreen(),
        ),
    );
  }
}