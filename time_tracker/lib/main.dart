import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Cadastrar Projeto';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  DateTime? initialDate;
  DateTime? finalDate;
  final intitialDateController = TextEditingController();
  final finalDateController = TextEditingController();
  final nomeController = TextEditingController();
  final tempoController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void dispose() {
    intitialDateController.dispose();
    finalDateController.dispose();
    nomeController.dispose();
    tempoController.dispose();
    valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: nomeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: tempoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tempo estimado',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: valorController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Valor cobrado',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: intitialDateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Data Inicial',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today,
                  lastDate: DateTime(today.year + 10));
              if (newDate != null) {
                String formattedDate = DateFormat('dd/MM/yyyy').format(newDate);
                setState(() {
                  initialDate = newDate;
                  intitialDateController.text = formattedDate;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: finalDateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Data Final',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate ?? today,
                  firstDate: initialDate ?? today,
                  lastDate: DateTime(today.year + 10));
              if (newDate != null) {
                String formattedDate = DateFormat('dd/MM/yyyy').format(newDate);
                setState(() {
                  finalDate = newDate;
                  finalDateController.text = formattedDate;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text('Projeto cadastrado com sucesso!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text('Cadastrar'),
            ),
          ),
        )
      ],
    );
  }
}
