import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/personagem.dart';

class TelaPersonagens extends StatefulWidget {
  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  ScrollController controllerScroll = ScrollController();
  int paginaAtual = 1;
  List<Personagem> listaPersonagens = [];

  Future<List> pageData() async {
    final response = await http.Client().get(Uri.parse(
        "https://rickandmortyapi.com/api/character?page=$paginaAtual"));
    if (response.statusCode == 200) {
      var meusDados = json.decode(response.body);
      List personagens = meusDados['results'];
      Map informacoes = meusDados['info'] as Map;

      if (informacoes['next'] != null) {
        debugPrint("Informacoes: $informacoes");

        personagens.forEach((personagem) {
          Map infoOrigem = personagem['origin'] as Map;
          Origin origin =
              Origin(name: infoOrigem['name'], url: infoOrigem['url']);
          Personagem p = Personagem(
              id: personagem['id'],
              name: personagem['name'],
              status: personagem['status'],
              species: personagem['species'],
              image: personagem['image'],
              origin: origin);
          listaPersonagens.add(p);
        });
        paginaAtual += 1;
      }

      return listaPersonagens;
    } else {
      throw Exception("Falha ao carregar os dados do personagem.");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool atualizou = false;
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Personagens")),
      body: FutureBuilder(
        initialData: const [],
        future: pageData(),
        builder: (context, snapshot) {
          List personagens = snapshot.data as List;
          return ListView.builder(
            controller: controllerScroll
              ..addListener(() {
                if (controllerScroll.position.pixels ==
                        controllerScroll.position.maxScrollExtent &&
                    atualizou == false) {
                  atualizou = true;
                  debugPrint("cheguei ao final da tela");
                  setState(() {});
                }
                // debugPrint("Posição: ${controllerScroll.position}");
                // debugPrint("Apareceu o controller");
              }),
            itemCount: personagens.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(personagens[index].name),
                subtitle: Text(personagens[index].status),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(personagens[index].image),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => maisInfo(personagens[index]),
                      ),
                    );
                  },
                  icon: const Icon(Icons.read_more),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class maisInfo extends StatelessWidget {
  Personagem personagens;
  maisInfo(this.personagens, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Personagem")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              (personagens.image),
            ),
            Text(
              "Nome: ${personagens.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Status: ${personagens.status}",
            ),
            Text("Espécie: ${personagens.species}"),
          ],
        ),
      ),
    );
  }
}
