import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('TASK NAME'),
      ),
      body: Center(child: _TaskActions()),
    ),
  ));
}

class _TaskActions extends StatelessWidget {
  const _TaskActions({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Cronometrar da tarefa iniciado."),
                duration: const Duration(milliseconds: 500),
              ));
            },
            icon: Icon(Icons.access_alarm),
            label: Text("Cronômetro da tarefa"),
          ),
          SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tarefa registrada como concluída."),
                duration: const Duration(milliseconds: 500),
              ));
            },
            icon: Icon(Icons.check_outlined),
            label: Text("Concluir tarefa"),
          ),
          SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.create_outlined),
            label: Text("Editar tarefa"),
          ),
          SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tarefa deletada."),
                duration: const Duration(milliseconds: 500),
              ));
            },
            icon: Icon(Icons.delete_outlined),
            label: Text("Deletar tarefa"),
          ),
        ],
      ),
    );
  }
}
