import 'package:flutter/material.dart';

class GraficoScreen extends StatefulWidget {
  const GraficoScreen({super.key});

  @override
  GraficoScreenState createState() => GraficoScreenState();
}

class GraficoScreenState extends State<GraficoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Cadastro de cotações"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
