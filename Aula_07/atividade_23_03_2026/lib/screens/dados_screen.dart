import 'package:flutter/material.dart';
import 'home_screen.dart';

class DadosScreen extends StatelessWidget {
  const DadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Pessoais'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(Icons.person, size: 50, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    nomeUsuario,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Informações Pessoais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            // Lista de dados pessoais
            Card(
              elevation: 2,
              child: Column(
                children: [
                  _itemLista(Icons.person, 'Nome Completo', nomeUsuario),
                  const Divider(height: 1),
                  _itemLista(Icons.email, 'E-mail', emailUsuario),
                  const Divider(height: 1),
                  _itemLista(Icons.badge, 'Matrícula', matriculaUsuario),
                  const Divider(height: 1),
                  _itemLista(Icons.school, 'Curso', cursoUsuario),
                ],
              ),
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

  Widget _itemLista(IconData icon, String label, String valor) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(valor, style: const TextStyle(fontSize: 15, color: Colors.black87)),
    );
  }
}
