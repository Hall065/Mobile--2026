import 'package:flutter/material.dart';

class TemperaturaScreen extends StatefulWidget {
  const TemperaturaScreen({super.key});

  @override
  State<TemperaturaScreen> createState() => _TemperaturaScreenState();
}

class _TemperaturaScreenState extends State<TemperaturaScreen> {
  int temperatura = 20;

  void _aumentarTemperatura() {
    setState(() {
      temperatura++;
    });
  }

  void _diminuirTemperatura() {
    setState(() {
      temperatura--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData tempIcon;
    String statusText;

    if (temperatura < 15) {
      backgroundColor = Colors.blue;
      tempIcon = Icons.ac_unit;
      statusText = 'Frio';
    } else if (temperatura < 30) {
      backgroundColor = Colors.green;
      tempIcon = Icons.wb_sunny;
      statusText = 'Agradável';
    } else {
      backgroundColor = Colors.red;
      tempIcon = Icons.local_fire_department;
      statusText = 'Quente';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Temperatura'),
        backgroundColor: Colors.transparent, // transparent to see scaffold background
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$temperatura°C',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              tempIcon,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _diminuirTemperatura,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.remove, size: 30),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: _aumentarTemperatura,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
