import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Icon(Icons.info, size: 80, color: Colors.deepPurple),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sobre o App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Este aplicativo foi criado como atividade prática da Aula 07 de Desenvolvimento Mobile 2026.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demonstra a navegação entre telas usando Navigator.push() do Flutter.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.school, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text('Aula 07 — Navegação em Flutter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.calendar_today, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text('23/03/2026', style: TextStyle(fontSize: 15)),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
