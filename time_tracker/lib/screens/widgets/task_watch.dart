import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/screens/task_details.dart';

final stopwatchModeProvider = StateProvider((ref) => true);
final timeProvider = StateProvider((ref) => '00:00');
final watchStateProvider = StateProvider((ref) => 0); // {zero = 0, started = 1, paused = 2}

String getMainButtonText(int state){
  if(state == 0) {
    return "Iniciar";
  }
  if(state == 1) {
    return "Pausar";
  } else {
    return "Parar";
  }
}

Widget getMainButtonIcon(int state){
  if(state == 0) {
    return const Icon(Icons.play_arrow_rounded);
  }
  if(state == 1) {
    return const Icon(Icons.pause_rounded);
  } else {
    return const Icon(Icons.stop_circle_outlined);
  }
}

class TaskWatch extends ConsumerWidget {
  TaskWatch({super.key, required this.task, required this.project});
  final Task task;
  final Project project;

  Stopwatch _stopwatch = Stopwatch();
  Stopwatch? _backupwatch;
  Timer _timer = Timer(Duration.zero, () { });
  Duration pomodoroDuration = const Duration(minutes: 1);

  String parseElapsedTime(bool stopWatchMode){
    if(stopWatchMode){
      return '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    Duration restToPomodoro = pomodoroDuration - _stopwatch.elapsed;
          return '${(restToPomodoro.inMinutes).toString().padLeft(2, '0')}:${(restToPomodoro.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void stopAll(){
    if(_timer != null){
      _timer.cancel();
    }
    _stopwatch.stop();
    _stopwatch.reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stopwatchModeProvider);
    ref.watch(timeProvider);
    ref.watch(watchStateProvider);

    bool isStopWatch = ref.read(stopwatchModeProvider.notifier).state;
    String timeText =  ref.read(timeProvider.notifier).state;
    int watchState = ref.read(watchStateProvider.notifier).state;

    void changeTimeMode(){
      if(_backupwatch != null && !isStopWatch){
        _stopwatch = _backupwatch!; 
        ref.read(timeProvider.notifier).state = parseElapsedTime(true);
      }else{
        if(isStopWatch) {//changes to Pomodoro
          _backupwatch = _stopwatch;
          ref.read(timeProvider.notifier).state = '25:00';
        }else{//changes to stopwatch
          ref.read(timeProvider.notifier).state = '00:00';
        }
        _stopwatch.stop();
        _stopwatch.reset();
      }
      ref.read(stopwatchModeProvider.notifier).state = !isStopWatch;
    }
    
    void handleMainButtonClick(bool retake){
      if(watchState == 0 || retake) { //iniciar
        ref.read(watchStateProvider.notifier).state = 1;
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          ref.read(timeProvider.notifier).state = parseElapsedTime(isStopWatch);
          if(!isStopWatch && _stopwatch.elapsed.inMinutes >= pomodoroDuration.inMinutes){//pomodoro finishes
            t.cancel();
            ref.read(watchStateProvider.notifier).state = 0;
            task.addSpentTime(_stopwatch.elapsed);
            project.addSpentTime(_stopwatch.elapsed);
            _stopwatch.reset();
            updateProjectTask(ref,project,task,false);
            if(pomodoroDuration.inMinutes == 25){
              pomodoroDuration = const Duration(minutes: 5);
            }else{
              pomodoroDuration = const Duration(minutes: 25);
            }
            ref.read(timeProvider.notifier).state = parseElapsedTime(isStopWatch);
          }
        });
      }
      else if(watchState == 1) {//pausar
        _timer.cancel();
        _stopwatch.stop();
        ref.read(watchStateProvider.notifier).state = 2;
      }
      else {//parar
        ref.read(watchStateProvider.notifier).state = 0;
        task.addSpentTime(_stopwatch.elapsed);
        project.addSpentTime(_stopwatch.elapsed);
        _stopwatch.reset();
        updateProjectTask(ref,project,task,false);
        ref.read(timeProvider.notifier).state = parseElapsedTime(isStopWatch);
      }
    }

    void handleResetButton() {
      _stopwatch.reset();
      if(!isStopWatch){
        _stopwatch.stop();
        ref.read(timeProvider.notifier).state = '25:00';
        ref.read(watchStateProvider.notifier).state = 0;
      }else{
        ref.read(timeProvider.notifier).state = parseElapsedTime(true);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(watchState ==0 ) ...[//change mode button
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
        ],
        if(pomodoroDuration.inMinutes == 5) ...[ //rest time message
          const Text("Descanso")
        ],
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
            if(isStopWatch) ...[ //stopwatch Buttons
            ElevatedButton.icon(
              onPressed: () => handleMainButtonClick(false),
              label: Text(getMainButtonText(watchState)),
              icon: getMainButtonIcon(watchState),
              style: ButtonStyle(backgroundColor: watchState == 2? MaterialStateProperty.all(Colors.red.shade300) : null),
            ),
            if(watchState == 2) ...[
              ElevatedButton.icon(
              onPressed: () => handleMainButtonClick(true),
              label: const Text('Continuar'),
              icon: getMainButtonIcon(0),
            ),
            ]
            ],
             if(!isStopWatch) ...[ //pomodoro Buttons
             if(watchState != 2) ...[
            ElevatedButton.icon(
              onPressed: () => handleMainButtonClick(false),
              label: Text(getMainButtonText(watchState)),
              icon: getMainButtonIcon(watchState),
            ),
             ],
            if(watchState == 2) ...[
              ElevatedButton.icon(
              onPressed: () => handleMainButtonClick(true),
              label: const Text('Continuar'),
              icon: getMainButtonIcon(0),
            ),
            ]
            ],
             if((isStopWatch && watchState != 2) || (!isStopWatch && watchState == 2)) ...[ //retake button
            ElevatedButton.icon(
              onPressed: watchState == 0? null : handleResetButton,
              label: const Text("Reiniciar"),
              icon: const Icon(Icons.restart_alt_rounded),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400]),
            ),
            ]
          ],
        ),
      ],
    );
  }
}
