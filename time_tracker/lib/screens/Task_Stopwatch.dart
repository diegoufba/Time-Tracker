import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conometro da Tarefa tal',
      home: TaskStopwatch(),
    );
  }
}

class TaskStopwatch extends StatefulWidget {
  const TaskStopwatch({super.key});

  @override
  State<TaskStopwatch> createState() => TaskStopwatchState();
}

class TaskStopwatchState extends State<TaskStopwatch> {
  Duration? _duration;

  final Stopwatch _stopwatch = Stopwatch();

  late Timer _timer;

  String _result = '00:00:00';

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        // result no formato hh:mm:ss
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  void _reset() {
    _stop();
    _duration = _stopwatch.elapsed;
    print(_duration.toString());
    _stopwatch.reset();

    // Update the UI
    setState(() {
      _result = '00:00:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conometro da Tarefa tal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _result,
              style: const TextStyle(
                fontSize: 120.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _start,
                  label: const Text("Start"),
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
                ElevatedButton.icon(
                  onPressed: _stop,
                  label: const Text("Stop"),
                  icon: const Icon(Icons.pause_rounded),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400]),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  label: const Text("Reset"),
                  icon: const Icon(Icons.restart_alt_rounded),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
