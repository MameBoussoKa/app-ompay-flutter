import 'package:flutter/material.dart';
import 'package:app_ompay_flutter/widgets/grid_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Accueil')),
      body: const Stack(
        children: [
          GridBackground(),
          Center(child: Text('Bienvenue sur la page d\'accueil!')),
        ],
      ),
    );
  }
}
