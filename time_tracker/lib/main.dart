import 'package:flutter/material.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/screens/projects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final projectsProvider = StateProvider((ref) => [
      Project("Desenvolvimento App mobile", 1300, null,
          DateTime.parse("2023-11-30"), const Duration(hours: 147, minutes: 23), 130, false, false, [
        Task("Definir Telas", DateTime.parse("2023-09-20"),
            DateTime.parse("2023-09-30"),  const Duration(hours: 12, minutes: 23), true),
        Task("Desenvolver Telas", DateTime.parse("2023-10-10"),
            DateTime.parse("2023-11-30"), const Duration(hours: 48), false),
        Task("Definir Classes", DateTime.parse("2023-10-10"),
            DateTime.parse("2023-10-15"), const Duration(hours: 48), false),
        Task("Adicionar estilos", null,null, const Duration(hours: 48), false),
      ]),
      Project("Criação Sistema Web", 45, DateTime.parse("2023-10-01"), DateTime.parse("2023-10-05"),
          const Duration(hours: 38, minutes: 25), 54, true, true, [
        Task("Criação de rotas", DateTime.parse("2023-09-20"),
            DateTime.parse("2023-09-21"), const Duration(hours: 8, minutes: 25), true),
        Task("Criação de telas", DateTime.parse("2023-09-22"),
            DateTime.parse("2023-09-25"), const Duration(hours: 16), true),
        Task("Integração com back-end", DateTime.parse("2023-09-26"),
            DateTime.parse("2023-09-28"), const Duration(hours: 8), true),
        Task("Melhorar estilos de componentes", DateTime.parse("2023-09-29"),
            DateTime.parse("2023-10-01"), const Duration(hours: 6), true),
      ]),
    ]);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Time Tracker",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Meus Projetos"),
        ),
        body: const ProjectsScreen(),
      ),
    );
  }
}
