import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopwatchModeProvider = StateProvider((ref) => true);
final timeProvider = StateProvider((ref) => '00:00:00');
final isPausedProvider = StateProvider((ref) => false);

class TaskWatch extends ConsumerWidget {
  TaskWatch({super.key});

  Duration? _duration;
  Stopwatch _stopwatch = Stopwatch();
  Stopwatch? _backupwatch;
  late Timer _timer;

  String parseElapsedTime(){
    return '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stopwatchModeProvider);
    ref.watch(timeProvider);

    bool isStopWatch = ref.read(stopwatchModeProvider.notifier).state;
    String timeText =  ref.read(timeProvider.notifier).state;
    bool isPaused = ref.read(isPausedProvider.notifier).state;

    void _start() {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
        ref.read(timeProvider.notifier).state = parseElapsedTime();
      });
      _stopwatch.start();
    }

    void _stop() {
      _timer.cancel();
      _stopwatch.stop();
      if(isPaused){

      }
      ref.read(isPausedProvider.notifier).state = !isPaused;
    }

    void _reset() {
      _stop();
      _duration = _stopwatch.elapsed;
      _stopwatch.reset();
      ref.read(timeProvider.notifier).state = '00:00:00';
    }

    void changeTimeMode(){
      if(_backupwatch != null){
        _stopwatch = _backupwatch!; 
        ref.read(timeProvider.notifier).state = parseElapsedTime();
      }else{
        _stopwatch = Stopwatch(); 
        if(isStopWatch) {
        ref.read(timeProvider.notifier).state = '25:00';
        }else{
          ref.read(timeProvider.notifier).state = '00:00:00';
        }
      }
      _backupwatch = _stopwatch;
      
      ref.read(stopwatchModeProvider.notifier).state = !isStopWatch;
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            changeTimeMode();
          },
          icon: Icon(
              !isStopWatch
                  ? Icons.access_time_filled_outlined
                  : Icons.alarm_on_outlined,
              color: !isStopWatch
                  ? Colors.deepPurple.shade300
                  : Colors.deepOrange.shade800),
          label: Text(!isStopWatch ? "Cronômetro" : "Pomodoro",
              style: TextStyle(
                  color: !isStopWatch
                      ? Colors.deepPurple.shade300
                      : Colors.deepOrange.shade800)),
        ),
        const SizedBox(height: 60),
        Text(
          timeText,
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
              label: const Text("Iniciar"),
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            ElevatedButton.icon(
              onPressed: _stop,
              label: Text(isPaused? "Encerrar" : "Pausar"),
              icon: Icon(isPaused? Icons.stop_circle_outlined : Icons.pause_rounded),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            ),
            ElevatedButton.icon(
              onPressed: _reset,
              label: const Text("Reiniciar"),
              icon: const Icon(Icons.restart_alt_rounded),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400]),
            ),
          ],
        ),
      ],
    );
  }
}
