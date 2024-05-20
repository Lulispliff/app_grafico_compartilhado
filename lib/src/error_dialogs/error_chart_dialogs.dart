import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class ChartErroDialog {
  static void selecioneUmaMoedaErro(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao gerar gráfico",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Você deve selecionar uma moeda para gerar o gráfico",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.color2)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
  }

  static void cotacaoNaoEncontradaErro(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao gerar gráfico",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Nenhuma cotação foi encontrada no período de tempo selecionado",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.color2)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
  }
}
