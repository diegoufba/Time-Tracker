import 'package:time_tracker/model/task.dart';

class Project{
   String _name;
   double? _price;
   DateTime? _deliveryDate;
   DateTime? _deadlineDate;
   double? _spentTime;
   double? _estimatedTime;
   bool _finished = false;
   bool _hourlyRate = false;
   List<Task> _tasks = List.empty();

  Project(this._name, double? price, this._deliveryDate, 
  this._deadlineDate, double? spentTime, this._estimatedTime,
  bool? finished, bool? hourlyRate, List<Task>? tasks){
    _price = price ?? 0;
    _spentTime = spentTime ?? 0;
    _finished = finished ?? _finished;
    _hourlyRate = hourlyRate ?? _finished;
    _tasks = tasks ?? _tasks;
  }

  void addTask(Task task){
    _tasks.add(task);
  }

  void removeTask(Task task){
    _tasks.remove(task);
  }

  int getNumberOfTaks(){
    return _tasks.length;
  }
   
}