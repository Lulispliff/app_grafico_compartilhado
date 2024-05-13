import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/models/indicador.dart';

class IndicadorScreen extends StatefulWidget {
  const IndicadorScreen({super.key});

  @override
  IndicadorScreenState createState() => IndicadorScreenState();
}

class IndicadorScreenState extends State<IndicadorScreen> {
  List<Indicador> indicadores = [];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Cadastro de indicadores"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      body: Column(
        children: [
          Expanded(
              child: indicadores.isEmpty
                  ? const Center(
                      child: Text(
                        "Sua lista de indicadores está vazia",
                        style: TextStyle(fontSize: 22),
                      ),
                    )
                  : listaIndicadores()),
          addIndicadorButton(context),
          navigatorButtons(context)
        ],
      ),
    );
  }

  Widget listaIndicadores() {
    return ListView.builder(itemBuilder: (context, index) {
      return null;
    });
  }

  Widget addIndicadorButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
                // ignore: sort_child_properties_last
                child: const Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.blue,
                shape: const CircleBorder(),
                onPressed: () {}),
          ),
        )
      ],
    );
  }

  Widget navigatorButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10),
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: const Text(
              "Gráfico",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10),
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: const Text(
              "Cotações",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
