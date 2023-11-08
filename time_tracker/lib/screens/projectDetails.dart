import 'package:flutter/material.dart';
import 'package:time_tracker/model/project.dart';

class ProjectDetailsScreen extends StatelessWidget {
   const ProjectDetailsScreen({super.key, required this.project});
   final Project project;
   
     @override
     Widget build(BuildContext context) {
      return(
        Text("Entrou no projeto: ${project.name}")
      );
     }
}