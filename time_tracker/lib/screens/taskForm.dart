import 'package:flutter/material.dart';


void main() => runApp(const FormExampleApp());

class FormExampleApp extends StatelessWidget {
  const FormExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cadastrar Tarefa')),
        body: const FormExample(),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _taskName;
  DateTime?  _initialDateTask;
  DateTime? _finalDateTask;
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Digite o nome da sua Tarefa',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite um nome';
              }
             _taskName = value;
             return null;
            },
          ),
          InputDatePickerFormField(
            errorFormatText: "Digite um formato válido",
            errorInvalidText: "Digie uma data entre 2019 e 2025",   
            fieldHintText: "Escreva uma data inicial para a tarefa no formato dd/mm/yyyy",
            fieldLabelText: "Escreva uma data inicial para a tarefa no formato dd/mm/yyyy",
            firstDate: DateTime(DateTime.now().year-1000),
            lastDate: DateTime(DateTime.now().year+1000),
            initialDate: _initialDateTask,
            onDateSubmitted: (date) {
              setState(() {
                _initialDateTask = date;
              });
            },
          ),
          InputDatePickerFormField(
            errorFormatText: "Digite um formato válido",
            errorInvalidText: "Digie uma data entre 1500 e 3800",
            fieldHintText: "Escreva uma data final para a tarefa no formato dd/mm/yyyy",
            fieldLabelText: "Escreva uma data final para a tarefa no formato dd/mm/yyyy",
            firstDate: DateTime(DateTime.now().year-1000),
            lastDate: DateTime(DateTime.now().year+1000),
            initialDate: _finalDateTask,
            onDateSubmitted: (date) {
              setState(() {
                _finalDateTask = date;
              });
            },
          ), 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('Cadastrar'),
            ),
          ),
        ],
      ),
    );
  }
}
