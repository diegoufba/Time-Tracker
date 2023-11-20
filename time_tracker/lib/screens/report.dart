import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/utils.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';

class Report extends ConsumerWidget {
  const Report({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(projectsProvider);

    // Gera valores aleatorios para o tempo de cada tarefa
    Map<String, double> dataMap = {};

    List<String> names = project.tasks.map((task) => task.name).toList();

    Random random = Random();
    double sum = 0;
    for (int i = 0; i < names.length - 1; i++) {
      double value = random.nextDouble() * (100 - sum);
      sum += value;
      dataMap[names[i]] = value;
    }
    dataMap[names.last] = 100 - sum;

    // ***************************

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                project.name,
                style: TextStyle(fontSize: 40),
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
                style: TextStyle(fontWeight: FontWeight.bold),
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
                "${project.spentTime} horas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            PieChart(
              dataMap: dataMap,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
            ),
          ],
        ),
      ),
    );
  }
}
