import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('TASK NAME'),
      ),
      body: _taskActions(),
    ),
  ));
}

class _taskActions extends StatelessWidget {
  const _taskActions({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ElevatedButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tarefa deletada."),
                duration: const Duration(milliseconds: 500),
              ));
              }, 
             icon: Icon(Icons.delete_outlined), 
             label: Text("Deletar tarefa"),  
        ),
        ElevatedButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Tarefa registrada como concluída."),
                duration: const Duration(milliseconds: 500),
              ));
              }, 
             icon: Icon(Icons.check_outlined), 
             label: Text("Concluir tarefa"),  

         ),        
        ElevatedButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Cronometrar da tarefa iniciado."),
                duration: const Duration(milliseconds: 500),
              ));
              }, 
             icon: Icon(Icons.access_alarm), 
             label: Text("Cronômetro da tarefa"),  
         ),        
        ElevatedButton.icon(
            onPressed: (){

              }, 
             icon: Icon(Icons.create_outlined), 
             label: Text("Editar tarefa"),  
         )        
           
      ],
    );
  }
}
