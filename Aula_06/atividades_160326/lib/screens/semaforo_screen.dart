import 'package:flutter/material.dart';

class SemaforoScreen extends StatefulWidget {
  const SemaforoScreen({super.key});

  @override
  State<SemaforoScreen> createState() => _SemaforoScreenState();
}

class _SemaforoScreenState extends State<SemaforoScreen> {
  int estado = 0; // 0 = Verde, 1 = Amarelo, 2 = Vermelho

  void _mudarSemaforo() {
    setState(() {
      estado = (estado + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPedestrianSafe = estado == 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semáforo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  _buildLuz(Colors.red, estado == 2),
                  const SizedBox(height: 10),
                  _buildLuz(Colors.yellow, estado == 1),
                  const SizedBox(height: 10),
                  _buildLuz(Colors.green, estado == 0),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Icon(
              isPedestrianSafe ? Icons.directions_walk : Icons.pan_tool,
              color: isPedestrianSafe ? Colors.green : Colors.red,
              size: 80,
            ),
            const SizedBox(height: 10),
            Text(
              isPedestrianSafe ? 'PEDESTRE: ATRAVESSE' : 'PEDESTRE: AGUARDE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isPedestrianSafe ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _mudarSemaforo,
              child: const Text('Mudar Semáforo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuz(Color cor, bool ativa) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: ativa ? cor : Colors.grey[800],
        shape: BoxShape.circle,
        boxShadow: ativa
            ? [
                BoxShadow(
                  color: cor.withValues(alpha: 255 * 0.5), // Corrected withOpacity
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : [],
      ),
    );
  }
}
