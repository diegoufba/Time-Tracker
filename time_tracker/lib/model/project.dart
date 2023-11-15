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

  String getDeadLineDateAsText(){
    if(_deadlineDate != null){
      // return "${_deadlineDate!.day}/${_deadlineDate!.month > 9? _deadlineDate!.month : "0${_deadlineDate!.month.toString()}"}/${_deadlineDate!.year} ${_deadlineDate!.hour > 9 ? _deadlineDate!.hour : "0${_deadlineDate!.hour.toString()}"}:${_deadlineDate!.minute > 9 ? _deadlineDate!.minute : "0${_deadlineDate!.minute}"}";
      return "${_deadlineDate!.day}/${_deadlineDate!.month > 9? _deadlineDate!.month : "0${_deadlineDate!.month.toString()}"}/${_deadlineDate!.year}";
    }
    return "";
  }

  String getDeliveryDateAsText(){
    if(_deliveryDate != null){
      // return "${_deliveryDate!.day}/${_deliveryDate!.month > 9? _deliveryDate!.month : "0${_deliveryDate!.month.toString()}"}/${_deliveryDate!.year} ${_deliveryDate!.hour > 9 ? _deliveryDate!.hour : "0${_deliveryDate!.hour.toString()}"}:${_deliveryDate!.minute > 9 ? _deliveryDate!.minute : "0${_deliveryDate!.minute}"}";
      return "${_deliveryDate!.day}/${_deliveryDate!.month > 9? _deliveryDate!.month : "0${_deliveryDate!.month.toString()}"}/${_deliveryDate!.year}";
    }
    return "";
  }

  set name(String name) => _name = name;

  set price(double price) => _price = price;

  set hourlyRate(bool hourlyRate) => _hourlyRate = hourlyRate;

  set deadlineDate(DateTime? deadlineDate) => _deadlineDate = deadlineDate;

  set deliveryDate(DateTime? deliveryDate) => _deliveryDate = deliveryDate;

  set finished(bool finished) => _finished = finished;

  set spentTime(double? time) => _spentTime = time;

  String get name => _name;

  List<Task> get tasks => _tasks;

  double get price => _price;

  DateTime? get deliveryDate => _deliveryDate;

  DateTime? get deadlineDate => _deadlineDate;

  double? get spentTime => _spentTime;
  
  double? get estimatedTime => _estimatedTime;

  bool get finished => _finished;

  bool get hourlyRate => _hourlyRate;

   String spentTimeAsText(){
    if(_spentTime == null || _spentTime == 0) return "Nenhum";
    List<String> tempos = _spentTime.toString().split('.');
    double minutos = tempos.length == 2? double.parse(tempos.elementAt(1).substring(0,2)) : 0;
    return "${tempos.elementAt(0)}H ${minutos}M";
  }
   
}