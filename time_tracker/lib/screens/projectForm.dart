import 'package:flutter/material.dart';

/// Flutter code sample for [Form].

void main() => runApp(const FormExampleApp());

class FormExampleApp extends StatelessWidget {
  const FormExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Sample')),
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
  String? _projectName;
  double? _priceProject;
  DateTime?  _deliveryDateProject;
  DateTime? _deadlineDateProject;
  double? _estimatedTimeProject;
  
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Digite o nome do seu Projeto',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite um nome';
              }
             _projectName = value;
             return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Digite o preço do seu Projeto',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
            if (value==null || value.isEmpty) {
              return 'Por favor, digite um preço';
            }
            double? aux = double.tryParse(value);
            if (aux == null || aux <= 0) {
              return 'Por favor, digite um preço válido';
              }
              _priceProject = aux;
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Digite o tempo estimado do seu Projeto',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
            if (value==null || value.isEmpty) {
              return 'Por favor, digite um tempo ';
            }
            double? aux = double.tryParse(value);
            if (aux == null || aux <= 0) {
              return 'Por favor, digite um tempo válido';
              }
              _estimatedTimeProject = aux;
              return null;
            },
          ),
          InputDatePickerFormField(
            errorFormatText: "Digite um formato válido",
            errorInvalidText: "Digie uma data entre 2019 e 2025",   
            fieldHintText: "Escreva uma data no formato dd/mm/yyyy",
            fieldLabelText: "Escreva uma data no formato dd/mm/yyyy",
            firstDate: DateTime(2019),
            lastDate: DateTime(2025),
            initialDate: _deliveryDateProject,
            onDateSubmitted: (date) {
              setState(() {
                _deliveryDateProject = date;
              });
            },
          ),
          InputDatePickerFormField(
            errorFormatText: "Digite um formato válido",
            errorInvalidText: "Digie uma data entre 2019 e 2025",
            fieldHintText: "Escreva uma data no formato dd/mm/yyyy",
            fieldLabelText: "Escreva uma data no formato dd/mm/yyyy",
            firstDate: DateTime(2019),
            lastDate: DateTime(2025),
            initialDate: _deadlineDateProject,
            onDateSubmitted: (date) {
              setState(() {
                _deadlineDateProject = date;
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
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}