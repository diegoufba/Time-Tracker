import 'package:time_tracker/model/task.dart';

class Project{
   String _name;
   double _price = 0;
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
    _price = price ?? _price;
    _spentTime = spentTime ?? 0;
    _finished = finished ?? _finished;
    _hourlyRate = hourlyRate ?? _finished;
    _tasks = tasks ?? _tasks;
  }

  void addTask(Task task){
    var tasklistcopy = _tasks.toList();
    tasklistcopy.add(task);
    _tasks = tasklistcopy;
  }

  void removeTask(Task task){
    _tasks.remove(task);
  }

  int getNumberOfTaks(){
    return _tasks.length;
  }

  String get name => _name;

  List<Task> get tasks => _tasks;

  double? get price => _price;

  DateTime? get deliveryDate => _deliveryDate;

  DateTime? get deadlineDate => _deadlineDate;

  double? get spentTime => _spentTime;
  
  double? get estimatedTime => _estimatedTime;

  bool get finished => _finished;

  bool get hourlyRate => _hourlyRate;
   
}