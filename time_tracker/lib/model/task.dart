class Task {
  String _name;
  DateTime? _initialDate;
  DateTime? _finalDate;
  double? _hour;
  bool _isCompleted = false;


  Task(this._name, this._initialDate, this._finalDate, this._hour, bool? isCompleted){
    _isCompleted = isCompleted ?? false;
  }

  void toggleCompleted() {
    _isCompleted = !_isCompleted;
  }

  String get name => _name;

}
