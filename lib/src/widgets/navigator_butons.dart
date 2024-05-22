import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class NavigatorButtons {
  static Widget buildNavigatorButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToGrafico(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Gráfico",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToCotacao(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Cotação",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToMoedas(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Moedas",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  static void goToGrafico(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  static void goToCotacao(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }

  static void goToMoedas(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MoedaScreen()));
  }
}
