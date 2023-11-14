class Task {
  final String _name;
  final DateTime _initialDate;
  final DateTime _finalDate;
  final double? _hour;
  bool _isCompleted = false;

  Task(this._name, this._initialDate, this._finalDate, this._hour, bool? isCompleted){
    _isCompleted = isCompleted ?? false;
  }

  void toggleCompleted() {
    _isCompleted = !_isCompleted;
  }

  String get name => _name;

  String getInitialDateAsText(){
    return "${_initialDate.day}/${_initialDate.month > 9? _initialDate.month : "0${_initialDate.month.toString()}"}/${_initialDate.year} ${_initialDate.hour > 9 ? _initialDate.hour : "0${_initialDate.hour.toString()}"}:${_initialDate.minute > 9 ? _initialDate.minute : "0${_initialDate.minute}"}";
  }

  String getFinalDateAsText(){
    return "${_finalDate.day}/${_finalDate.month > 9? _finalDate.month : "0${_finalDate.month.toString()}"}/${_finalDate.year} ${_finalDate.hour > 9 ? _finalDate.hour : "0${_finalDate.hour.toString()}"}:${_finalDate.minute > 9 ? _finalDate.minute : "0${_finalDate.minute}"}";
  }

  String getHourAsText(){
    if(_hour == null || _hour == 0) return "Nenhum";
    List<String> tempos = _hour.toString().split('.');
    double minutos = tempos.length == 2? double.parse(tempos.elementAt(1).substring(0,2)) : 0;
    return "${tempos.elementAt(0)}H ${minutos}M";
  }

  bool get isCompleted => _isCompleted;

  double? get hour => _hour;

  set isCompleted(bool isCompleted){
    _isCompleted = isCompleted;
  }

}
