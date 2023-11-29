// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

Future<DateTime?> pickOnlyDate(BuildContext context) async {
  return pickDate(context, DateTime.now());
}

Future<DateTime?> pickDateTime(BuildContext context) async {
  DateTime timeNow = DateTime.now();
  DateTime? newDate = await pickDate(context, timeNow);
  if (newDate == null) return null;

  TimeOfDay? newTime = await pickTime(context, timeNow);
  if (newTime != null) {
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );
  }

  return null;
}

Future<DateTime?> pickDate(BuildContext context, DateTime timeNow) =>
    showDatePicker(
        context: context,
        initialDate: timeNow,
        firstDate: timeNow.subtract(const Duration(days: 30)),
        cancelText: "Cancelar",
        errorFormatText: "Formato inválido",
        errorInvalidText: "Texto inválido",
        locale: const Locale('pt', 'BR'),
        lastDate: DateTime(timeNow.year + 10));

Future<TimeOfDay?> pickTime(BuildContext context, DateTime timeNow) =>
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute),
      cancelText: "Cancelar",
      errorInvalidText: "Texto inválido",
    );

Color getTaskStatusColor(String status) {
  switch (status) {
    case "Pendente":
      return Colors.grey.shade300;
    case "Em andamento":
      return Colors.amber.shade700;
    case "Completa":
      return Colors.greenAccent.shade400;
    case "Atrasada":
      return Colors.red.shade200;
    default:
      return Colors.black;
  }
}
