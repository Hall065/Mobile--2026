import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> opcoes = ['pedra', 'papel', 'tesoura'];
  
  IconData iconeComputador = Icons.help_outline;
  String resultado = 'Faça sua escolha!';
  int pontosJogador = 0;
  int pontosComputador = 0;

  void _jogar(String escolhaJogador) {
    if (pontosJogador >= 5 || pontosComputador >= 5) {
      return; // Jogo já acabou
    }

    final escolhaComputador = opcoes[Random().nextInt(3)];

    setState(() {
      // Atualiza ícone do PC
      switch (escolhaComputador) {
        case 'pedra':
          iconeComputador = Icons.landscape;
          break;
        case 'papel':
          iconeComputador = Icons.pan_tool;
          break;
        case 'tesoura':
          iconeComputador = Icons.content_cut;
          break;
      }

      // Lógica do jogo
      if (escolhaJogador == escolhaComputador) {
        resultado = 'Empate!';
      } else if ((escolhaJogador == 'pedra' && escolhaComputador == 'tesoura') ||
          (escolhaJogador == 'papel' && escolhaComputador == 'pedra') ||
          (escolhaJogador == 'tesoura' && escolhaComputador == 'papel')) {
        resultado = 'Você venceu a rodada!';
        pontosJogador++;
      } else {
        resultado = 'Computador venceu a rodada!';
        pontosComputador++;
      }

      // Verifica campeonato
      if (pontosJogador == 5) {
        resultado = '🏆 VOCÊ É O CAMPEÃO! 🏆';
        _mostrarDialogoFimDeJogo('Você Venceu!');
      } else if (pontosComputador == 5) {
        resultado = '☠️ O COMPUTADOR VENCEU! ☠️';
        _mostrarDialogoFimDeJogo('Você Perdeu!');
      }
    });
  }

  void _mostrarDialogoFimDeJogo(String titulo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: const Text('O campeonato terminou. Deseja jogar novamente?'),
          actions: [
            TextButton(
              child: const Text('Jogar Novamente'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetarPlacar();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetarPlacar() {
    setState(() {
      pontosJogador = 0;
      pontosComputador = 0;
      resultado = 'Faça sua escolha!';
      iconeComputador = Icons.help_outline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Computador',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Icon(
              iconeComputador,
              size: 100,
            ),
            const SizedBox(height: 40),
            Text(
              resultado,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              'Você: $pontosJogador | PC: $pontosComputador',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.landscape),
                  iconSize: 60,
                  onPressed: () => _jogar('pedra'),
                  tooltip: 'Pedra',
                ),
                IconButton(
                  icon: const Icon(Icons.pan_tool),
                  iconSize: 60,
                  onPressed: () => _jogar('papel'),
                  tooltip: 'Papel',
                ),
                IconButton(
                  icon: const Icon(Icons.content_cut),
                  iconSize: 60,
                  onPressed: () => _jogar('tesoura'),
                  tooltip: 'Tesoura',
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _resetarPlacar,
              icon: const Icon(Icons.refresh),
              label: const Text('Resetar Placar'),
            ),
          ],
        ),
      ),
    );
  }
}
