import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class MoedaErroDialog {
  static void addMoedaErro(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao adicionar moeda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Você deve atribuir um nome para a moeda que está adicionando.",
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

  static void editMoedaErro(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao editar moeda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Você deve inserir um novo nome para a moeda que está editando.",
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
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
