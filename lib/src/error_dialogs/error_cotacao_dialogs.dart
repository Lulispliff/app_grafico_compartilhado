import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class CotacaoErroDialog {
  static void addCotacaoErro(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao adicionar cotação",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Preencha todos os campos para poder adicionar uma cotação.",
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
