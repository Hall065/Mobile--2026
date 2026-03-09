import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HumorApp(),
    ),
  );
}

class HumorApp extends StatefulWidget {
  const HumorApp({super.key});

  @override
  State<HumorApp> createState() => _HumorAppState();
}

class _HumorAppState extends State<HumorApp> {

  int indiceHumor = 0;

  List<String> humores = [
    "Alegria",
    "Tristeza",
    "Raiva",
    "Medo",
    "Nojo"
  ];

  List<Color> cores = [
    Colors.yellow,
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green
  ];

  List<IconData> icones = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sick
  ];

  void trocarHumor() {
    setState(() {
      indiceHumor = (indiceHumor + 1) % humores.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cores[indiceHumor],
      appBar: AppBar(
        backgroundColor: cores[indiceHumor],
        title: const Text("Botão de Humor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icones[indiceHumor],
              size: 120,
            ),

            const SizedBox(height: 20),

            Text(
              humores[indiceHumor],
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: trocarHumor,
              child: const Text("Mudar Humor"),
            ),
          ],
        ),
      ),
    );
  }
}