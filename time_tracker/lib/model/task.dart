// ignore_for_file: unnecessary_getters_setters

class Task {
  String _name;
  DateTime? _initialDate; //data de início
  DateTime? _finalDate; //prazo
  Duration? _spentTime;
  bool _isCompleted = false;

  Task(this._name, this._initialDate, this._finalDate, this._spentTime,
      bool? isCompleted) {
    _isCompleted = isCompleted ?? false;
  }

  void toggleCompleted() {
    _isCompleted = !_isCompleted;
  }

  String get name => _name;

  String getInitialDateAsText() {
    if (_initialDate == null) return "";
    return "${_initialDate!.day}/${_initialDate!.month > 9 ? _initialDate!.month : "0${_initialDate!.month.toString()}"}/${_initialDate!.year} ${_initialDate!.hour > 9 ? _initialDate!.hour : "0${_initialDate!.hour.toString()}"}:${_initialDate!.minute > 9 ? _initialDate!.minute : "0${_initialDate!.minute}"}";
  }

  String getFinalDateAsText() {
    if (_finalDate == null) return "";
    return "${_finalDate!.day}/${_finalDate!.month > 9 ? _finalDate!.month : "0${_finalDate!.month.toString()}"}/${_finalDate!.year} ${_finalDate!.hour > 9 ? _finalDate!.hour : "0${_finalDate!.hour.toString()}"}:${_finalDate!.minute > 9 ? _finalDate!.minute : "0${_finalDate!.minute}"}";
  }

  String getHourAsText() {
    if (_spentTime == null ||
        (_spentTime != null && _spentTime!.inSeconds == 0)) return "Nenhum";
    List<String> tempos = _spentTime.toString().split('.');
    double minutos = tempos.length == 2
        ? double.parse(tempos.elementAt(1).substring(0, 2))
        : 0;
    return "${tempos.elementAt(0)}H ${minutos}M";
  }

  String getStatus() {
    if (_isCompleted) {
      return "Completa";
    }
    if (_finalDate != null && _finalDate!.compareTo(DateTime.now()) < 0) {
      return "Atrasada";
    }
    if (_initialDate == null) {
      return "Pendente";
    }
    return "Em andamento";
  }

  void addSpentTime(Duration time) {
    if (_spentTime != null) {
      _spentTime = _spentTime! + time;
    } else {
      _spentTime = time;
    }
  }

  DateTime? get initialDate => _initialDate;

  DateTime? get finalDate => _finalDate;

  bool get isCompleted => _isCompleted;

  Duration? get spentTime => _spentTime;

  set isCompleted(bool isCompleted) {
    _isCompleted = isCompleted;
  }

  set name(String name) => _name = name;

  set initialDate(DateTime? initialDate) => _initialDate = initialDate;

  set finalDate(DateTime? finalDate) => _finalDate = finalDate;

  set spentTime(Duration? spentTime) => _spentTime = spentTime;
}
