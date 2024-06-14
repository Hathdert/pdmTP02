import 'package:flutter/material.dart';
import 'package:pl04/menu.dart';

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione dificuldade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildDifficultyButton(context, 'Facil'),
            _buildDifficultyButton(context, 'Medio'),
            _buildDifficultyButton(context, 'Dificil'),
            _buildDifficultyButton(context, 'Infinito'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform logout action
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty) {
    return ElevatedButton(
      onPressed: () {
        // Button action for each difficulty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected difficulty: $difficulty'),
          ),
        );
      },
      child: Text(difficulty),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DifficultySelectionPage(),
  ));
}
