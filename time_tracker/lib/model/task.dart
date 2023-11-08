class Task {
  String? _title;
  DateTime? _initialDate;
  DateTime? _finalDate;
  String? _hour;
  bool _isCompleted = false;


  Task(this._title, this._initialDate, this._finalDate, this._hour, bool? isCompleted){
    _isCompleted = isCompleted ?? false;
  }

  void toggleCompleted() {
    _isCompleted = !_isCompleted;
  }

  String get name => _title;

}
