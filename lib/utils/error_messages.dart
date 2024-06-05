import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class ErrorMessages {
  static void cotacaoAddErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: AppColors.color4,
          title: Text("Cadastro de cotações", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
              color: AppColors.color2,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: AppColors.color2,
                size: 40,
              ),
              Text(
                "Preencha todos os campos corretamente!",
                style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  static void graficoMoedaErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: AppColors.color4,
          title: Text("Gráfico de cotações", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
              color: AppColors.color2,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.info, color: AppColors.color2, size: 40),
              Text(
                "Você deve selecionar uma moeda para gerar o gráfico!",
                style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  static void graficoCotacaoErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: AppColors.color4,
          title: Text("Gráfico de cotações", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
              color: AppColors.color2,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.info, color: AppColors.color2, size: 40),
              Text(
                "Nenhuma cotação foi encontrada no período de tempo selecionado!",
                style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  static void moedaNomeErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: AppColors.color4,
          title: Text("Cadastro de moedas", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
              color: AppColors.color2,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.info, color: AppColors.color2, size: 40),
              Text(
                "Insira um nome para a moeda!",
                style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  static void moedaNovoNomeErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Edição de moedas", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
              color: AppColors.color2,
              fontSize: 30,
              fontWeight: FontWeight.bold),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.info, color: AppColors.color2, size: 40),
              Text(
                "Você deve inserir um novo nome para a moeda que está editando!",
                style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  static void errorGraficoNavigatorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.chartColumn, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela do Gráfico!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void errorCotacaoNavigatorDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.fileInvoiceDollar, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela de Cotações!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void errorMoedaNavigatorDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.coins, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela de Moedas!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
