import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/episodios.dart';

class TelaEpisodios extends StatefulWidget {
  const TelaEpisodios({super.key});

  @override
  State<TelaEpisodios> createState() => _TelaEpisodiosState();
}

class _TelaEpisodiosState extends State<TelaEpisodios> {
  ScrollController controllerScroll = ScrollController();
  List<Episodio> listaEpisodios = [];
  int paginaAtual = 1;

  Future<List> pageData() async {
    final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/episode"));
    if (response.statusCode == 200) {
      var meusDados = json.decode(response.body);
      List episodios = meusDados['results'];
      Map informacoes = meusDados['info'] as Map;

      if (informacoes['next'] != null) {
        debugPrint("Informacoes: $informacoes");
        episodios.forEach((episodio) {
          Episodio e = Episodio(
            id: episodio['id'],
            name: episodio['name'],
            airDate: episodio['air_date'],
            episode: episodio['episode'],
            created: episodio['created'],
          );
          listaEpisodios.add(e);
        });
        paginaAtual += 1;
      }
      return listaEpisodios;
    } else {
      throw Exception("Falha ao carregar os dados do local.");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool atualizou = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela de EPs"),
      ),
      body: FutureBuilder(
        initialData: const [],
        future: pageData(),
        builder: (context, snapshot) {
          List episodios = snapshot.data as List;
          return ListView.builder(
            controller: controllerScroll
              ..addListener(() {
                if (controllerScroll.position.pixels ==
                        controllerScroll.position.maxScrollExtent &&
                    atualizou == false) {
                  atualizou = true;
                  setState(() {});
                }
              }),
            itemCount: episodios.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(episodios[index].name),
                subtitle: Text(episodios[index].episode),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => maisInfo(episodios[index]),
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
  Episodio ep;
  maisInfo(this.ep, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ep.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tipo: ${ep.episode}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Dimensão: ${ep.airDate}"),
            Text("Criado em: ${ep.created}")
          ],
        ),
      ),
    );
  }
}
