import 'package:flutter/material.dart';
import 'boasvindas_screen.dart';
import 'dados_screen.dart';

// Dados do usuário compartilhados entre telas
const String nomeUsuario = 'João da Silva';
const String emailUsuario = 'joao.silva@escola.edu.br';
const String cursoUsuario = 'Desenvolvimento Mobile 2026';
const String matriculaUsuario = '2026001';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar do usuário
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.deepPurple.shade100,
              child: const Icon(Icons.person, size: 60, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Text(
              nomeUsuario,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              emailUsuario,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Divider(),
            // Card com dados principais
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _dadoItem(Icons.badge, 'Matrícula', matriculaUsuario),
                    const Divider(height: 20),
                    _dadoItem(Icons.school, 'Curso', cursoUsuario),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Botões de navegação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.waving_hand),
                    label: const Text('Boas Vindas'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BoasVindasScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Meus Dados'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DadosScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dadoItem(IconData icon, String label, String valor) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
