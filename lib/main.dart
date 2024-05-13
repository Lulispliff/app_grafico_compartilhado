import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MoedaDatabase.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => MoedaDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoedaScreen(),
    );
  }
}
