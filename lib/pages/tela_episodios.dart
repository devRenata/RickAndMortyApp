import 'package:flutter/material.dart';

class TelaEpisodios extends StatefulWidget {
  const TelaEpisodios({super.key});

  @override
  State<TelaEpisodios> createState() => _TelaEpisodiosState();
}

class _TelaEpisodiosState extends State<TelaEpisodios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela de EPs"),
      ),
      body: Column(
        children: [
          Text("Corpo da tela")
        ],
      ),
    );
  }
}