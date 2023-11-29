import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:pie_chart/pie_chart.dart';

class Report extends ConsumerWidget {
  const Report({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(projectsProvider);

    Map<String, double> dataMap = {};
    if (project.tasks.isNotEmpty) {
      double totalTime = 0;
      for (var task in project.tasks) {
        totalTime += task.spentTime != null ? task.spentTime!.inSeconds : 0;
      }
      for (var task in project.tasks) {
        double value = task.spentTime != null
            ? (task.spentTime!.inSeconds * 100) / totalTime
            : 0;
        dataMap[task.name] = value;
      }
    }
    // ***************************

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  project.name,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("TEMPO ESTIMADO"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${project.estimatedTime} horas",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("TEMPO GASTO"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  project.spentTime != null
                      ? "${project.spentTime!.inHours != 0 ? "${project.spentTime!.inHours} horas " : ""} ${project.spentTime!.inMinutes % 60 != 0 ? "${project.spentTime!.inMinutes % 60} minutos " : ""} ${project.spentTime!.inMinutes == 0 ? "${project.spentTime!.inSeconds} segundos" : ""}"
                      : "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              if (dataMap.isEmpty) ...[
                const Text(
                  "Nenhum registro de tempo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
              if (dataMap.isNotEmpty) ...[
                PieChart(
                  dataMap: dataMap,
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true),
                  chartRadius: MediaQuery.of(context).size.width / 4.2,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
