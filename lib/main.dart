import 'package:api_rick_and_morty/pages/tela_episodios.dart';
import 'package:api_rick_and_morty/pages/tela_locais.dart';
import 'package:flutter/material.dart';
import 'pages/tela_personagens.dart';

void main() {
  runApp(MaterialApp(home: PaginaInicial()));
}

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty API"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Personagens
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaPersonagens(),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    "images/characters.png",
                    width: 120,
                    height: 120,
                  ),
                  const Text("Personagens"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaLocais(),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    "images/locations.png",
                    width: 120,
                    height: 120,
                  ),
                  const Text("Locais"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaEpisodios(),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    "images/episodes.png",
                    width: 120,
                    height: 120,
                  ),
                  const Text("Episódios")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
