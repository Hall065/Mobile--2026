import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PaginaRandom(),
  ));
}

class PaginaRandom extends StatefulWidget {
  const PaginaRandom({super.key});

  @override
  State<PaginaRandom> createState() => _PaginaRandomState();
}

class _PaginaRandomState extends State<PaginaRandom> {
  int nRandom = 0;

  void sortear() {
    setState(() {
      nRandom = Random().nextInt(11); // gera número random de 0 a 10
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu App Interativo")),
      body: Center(
        child: Text(
          "Número Random: $nRandom",
          style: const TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sortear,
        child: const Icon(Icons.casino),
      ),
    );
  }
}