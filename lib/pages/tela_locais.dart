import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/locais.dart';

class TelaLocais extends StatefulWidget {
  const TelaLocais({super.key});

  @override
  State<TelaLocais> createState() => _TelaLocaisState();
}

class _TelaLocaisState extends State<TelaLocais> {
  ScrollController controllerScroll = ScrollController();
  List<Locais> listaLocais = [];
  int paginaAtual = 1;

  Future<List> pageData() async {
    final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/location"));
    if (response.statusCode == 200) {
      var meusDados = json.decode(response.body);
      List locais = meusDados['results'];
      Map informacoes = meusDados['info'] as Map;

      if (informacoes['next'] != null) {
        debugPrint("Informacoes: $informacoes");
        locais.forEach((local) {
          Locais l = Locais(
            id: local['id'],
            name: local['name'],
            type: local['type'],
            dimension: local['dimension'],
          );
          listaLocais.add(l);
        });
        paginaAtual += 1;
      }
      return listaLocais;
    } else {
      throw Exception("Falha ao carregar os dados do personagem.");
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
          List locais = snapshot.data as List;
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
            itemCount: locais.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(locais[index].name),
                subtitle: Text(locais[index].type),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => maisInfo(locais[index]),
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
  Locais local;
  maisInfo(this.local, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do local")),
      body: const Text("corpo de detalhes do local"),
    );
  }
}