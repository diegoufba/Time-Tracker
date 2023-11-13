import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('TASK NAME'),
      ),
      body: const Center(child: _TaskActions()),
    ),
  )));
}

class _TaskActions extends StatelessWidget {
  const _TaskActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Cronometrar da tarefa iniciado."),
              duration: Duration(milliseconds: 500),
            ));
          },
          icon: const Icon(Icons.access_alarm),
          label: const Text("Cronômetro da tarefa"),
        ),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Tarefa registrada como concluída."),
              duration: Duration(milliseconds: 500),
            ));
          },
          icon: const Icon(Icons.check_outlined),
          label: const Text("Concluir tarefa"),
        ),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.create_outlined),
          label: const Text("Editar tarefa"),
        ),
        const SizedBox(height: 25),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Tarefa deletada."),
              duration: Duration(milliseconds: 500),
            ));
          },
          icon: const Icon(Icons.delete_outlined),
          label: const Text("Deletar tarefa"),
        ),
      ],
    );
  }
}
