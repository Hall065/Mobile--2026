import 'package:flutter/material.dart';
import 'semaforo_screen.dart';
import 'temperatura_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projeto Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SemaforoScreen()),
                );
              },
              icon: const Icon(Icons.traffic),
              label: const Text('Semáforo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TemperaturaScreen()),
                );
              },
              icon: const Icon(Icons.thermostat),
              label: const Text('Temperatura'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Mini Game'),
            ),
          ],
        ),
      ),
    );
  }
}
